# dr_spec - Framework de test RSpec-like pour DragonRuby

## Description

dr_spec est un framework de test qui reproduit la syntaxe RSpec pour DragonRuby Game Toolkit (DRGTK). Il fournit un DSL (`spec`, `context`, `it`, `before`, `after`, `expect(...).to`), des matchers, des shared examples, et un output formaté en couleurs.

Repo : `levaleureux/dr_spec` (GitHub)
Rôle dans l'écosystème drgame : lib partagée utilisée comme framework de test dans tous les autres projets (draw_my_dream, colider_beta, dr_colider).

## Structure

```
dr_spec/
├── app/tests.rb                        # Point d'entrée des tests
├── lib/dr_spec/
│   ├── dragon_specs.rb                 # Orchestrateur : requires + run_specs
│   ├── core_matchers.rb                # Classe de base CoreMatcher
│   ├── tests_formater.rb              # Formatage couleur (ANSI)
│   ├── core/
│   │   ├── world.rb                    # DrSpec::World — singleton, registre des groups/shared
│   │   ├── example_group.rb            # DrSpec::ExampleGroup — noeud de l'arbre (spec/context)
│   │   ├── example.rb                  # DrSpec::Example — feuille (it/xit)
│   │   ├── example_context.rb          # DrSpec::ExampleContext — objet frais par test (isolation)
│   │   ├── metadata.rb                # DrSpec::Metadata — tags, focus
│   │   ├── configuration.rb           # DrSpec::Configuration — format_mode, log_level
│   │   ├── dsl.rb                      # DSL top-level : spec, context, it, before, after, shared_examples
│   │   ├── utils.rb                    # AssertionWrapper, Expectation, to_snake_case
│   │   └── patch.rb                    # Extension de GTK::Tests (monkey-patch)
│   └── matchers/
│       ├── matchers.rb                 # eq (EqualMatcher)
│       ├── boolean_matchers.rb         # be_truthy, be_falsy, be_nil
│       ├── collection_matchers.rb      # include, contain, have_size, be_empty, contain_exactly, include_elements_in_order
│       ├── numeric_comparison_matchers.rb  # be_greater_than, be_less_than, etc.
│       ├── string_matchers.rb          # start_with, end_with, match
│       └── type_matchers.rb            # be_instance_of, be_kind_of (pas de tests)
├── spec/                               # Tests du framework (auto-test)
│   ├── matchers_1_spec.rb              # String + Collection matchers
│   ├── matchers_2_spec.rb              # Numeric + Boolean + nested contexts
│   ├── shared_examples_spec.rb         # Shared examples
│   ├── architecture_spec.rb           # Tests de l'architecture class-based + isolation
│   ├── metadata_spec.rb               # Metadata filtering (WIP)
│   └── main_spec.rb                   # Appel run_specs
├── spec_cli/                           # Tests RSpec pour fonctionnalités CLI
│   ├── spec_helper.rb                  # Setup RSpec + SimpleCov
│   ├── filters_spec.rb                # Filtrage CLI (TODO)
│   └── work_on_fixtures_spec.rb       # Manipulation de fixtures
├── Guardfile                           # Auto-run des tests (guard-shell)
├── Gemfile                             # Dépendances Ruby (guard, rspec)
├── run_tests                           # Script shell pour lancer les tests
└── README.md                           # Doc principale (anglais)
```

## Architecture

### Architecture 2-pass (class-based)

dr_spec utilise une architecture en 2 passes :

**Phase 1 — Build (au require-time)** : Le DSL (`spec`, `context`, `it`, `before`, `after`) construit un arbre d'objets via `DrSpec::World` :
- `DrSpec::ExampleGroup` : noeuds de l'arbre (spec/context), avec befores, afters, children
- `DrSpec::Example` : feuilles (it/xit), référencent leur group parent
- `DrSpec::Metadata` : tags, focus, filtrage

**Phase 2 — Run** : `DrSpec::World#build_test_methods!` parcourt l'arbre en DFS et génère les méthodes `test_*` sur Object via `define_method`. Chaque test crée un `DrSpec::ExampleContext` frais (sous-classe anonyme) pour l'isolation des `@vars` et des `def`.

### Comment le framework étend GTK::Tests

DragonRuby fournit une classe `GTK::Tests` intégrée. dr_spec la monkey-patche via `core/patch.rb` pour :
- Détecter les méthodes `test_*` et `focus_test_*` générées par le DSL
- Exécuter les tests avec gestion des exceptions
- Afficher un résumé formaté avec couleurs et icônes

### Flux d'exécution

1. `app/tests.rb` → require `dragon_specs.rb`
2. `dragon_specs.rb` charge toutes les libs puis les fichiers spec
3. **Phase 1** : Chaque `spec` block construit un arbre d'ExampleGroup/Example dans World
4. `run_specs` appelle `World.instance.build_test_methods!` (Phase 2) puis `$gtk.tests.start`
5. Chaque `test_*` crée un ExampleContext frais, exécute befores → it → afters dessus
6. `patch.rb` formate et affiche les résultats

### Classes principales

| Classe | Rôle |
|--------|------|
| `DrSpec::World` | Singleton, registre des groups et shared_examples, génère les test methods |
| `DrSpec::ExampleGroup` | Noeud de l'arbre (spec/context), collected_befores/afters via chaîne parent |
| `DrSpec::Example` | Feuille (it/xit), `#run` crée un ExampleContext frais et exécute le test |
| `DrSpec::ExampleContext` | Objet frais par test pour l'isolation (sous-classe anonyme via Class.new) |
| `DrSpec::Metadata` | Données de filtrage : focus, tags |
| `DrSpec::Configuration` | format_mode, log_level |

### Pattern CoreMatcher

Chaque matcher hérite de `CoreMatcher` et implémente `positive_match?(actual)` qui retourne `[boolean, error_message]`. Les méthodes `match?` et `unmatch?` gèrent `to` et `not_to`.

```ruby
class MonMatcher < CoreMatcher
  def positive_match?(actual)
    [actual == @expected, "#{actual} n'est pas égal à #{@expected}"]
  end
end

def mon_matcher(expected, fail_with: "")
  MonMatcher.new(expected, fail_with)
end
```

### Chaîne d'assertion

`expect(value)` → `Expectation` → `.to(matcher)` appelle `matcher.match?(assert, value)`
Le chaînage `.and` retourne `self` pour permettre `expect(x).to(eq 1).and.to(eq 1)`.

## Limitations DragonRuby / mruby

DragonRuby utilise mruby, pas CRuby. Certaines fonctionnalités Ruby standard sont absentes :

- **Pas de Regexp** : `Regexp` n'existe pas. Le matcher `match` (regex) ne peut pas être utilisé. Ne pas écrire de tests avec des expressions régulières (`/pattern/`).
- **Pas de `require`** : utiliser `require_relative` ou le `require` custom de DragonRuby (chemin depuis la racine du projet).
- **`it` est réservé** : en Ruby 3.4+ (DR 6.x), `it` est un mot-clé. Utiliser `specify` à la place.

## Conventions de code

- **Nommage** : snake_case partout, matchers en snake_case avec préfixe (`be_`, `have_`, `start_`, `end_`)
- **Pattern matcher** : classe `XxxMatcher < CoreMatcher` + fonction helper `xxx(expected, fail_with: "")`
- **Specs** : `spec "description" do ... end` avec `specify`, `context`, `before`, `after`
- **Blocs de test** : signature `do ... end` (v2 — les `|args, assert|` ne sont plus nécessaires)
- **Description** : `:symbole` ou `"string"` pour spec/specify
- **`it` est réservé** : utiliser `specify` (Ruby 3.4+ / DragonRuby 6.x)

## Commandes

```bash
# Lancer les tests (mode quiet — recommandé pour les agents IA, économise les tokens)
./dragonruby-macos/dragonruby projects/dr_spec/mygame --eval app/tests.rb --no-tick --quiet --exit-on-fail

# Lancer les tests (mode dots — par défaut)
./dragonruby-macos/dragonruby projects/dr_spec/mygame --eval app/tests.rb --no-tick

# Lancer les tests (mode doc — arbre indenté des specs)
./dragonruby-macos/dragonruby projects/dr_spec/mygame --eval app/tests.rb --no-tick --doc

# Lancer depuis le dossier dr_spec (script intégré)
./run_tests

# Guard (auto-run sur modification)
bundle exec guard

# Tests RSpec CLI
bundle exec rspec spec_cli/
```

## Git — workflow git flow

- Remote : `git@github-valeureux.com:levaleureux/dr_spec.git`
- Identity : `levaleureux <133817850+levaleureux@users.noreply.github.com>`

### Branches

| Branche | Rôle |
|---------|------|
| `master` | Production stable. **Ne jamais commiter directement dessus.** |
| `develop` | Branche d'intégration. Les features sont mergées ici. |
| `feature/*` | Branches de d��veloppement, créées depuis `develop`. |

### Workflow

1. Créer une branche `feature/xxx` depuis `develop`
2. Développer et commiter sur la feature branch
3. Push + PR vers `develop`
4. **Ouvrir la PR dans le navigateur** pour relecture avant merge
5. Releases : merge `develop` → `master` avec tag de version

```bash
git checkout -b feature/ma_feature origin/develop
git push -u origin feature/ma_feature
gh pr create --base develop
```

**IMPORTANT** : ne jamais commiter ni push directement sur `master`. Toujours passer par `feature/* → develop → master`.

### Règles PR

- **Toujours ouvrir la PR dans le navigateur** (`gh pr view --web`) avant de demander un merge
- **Inclure une synthèse pour le relecteur** dans le body de la PR : résumé des changements, fichiers clés modifiés, ce qu'il faut vérifier
- **Vérifier que la CI est verte** avant de merge (`gh pr checks`)
- **Fermer les issues liées** après le merge
- **Nettoyer** : pas de fichiers temp, pas de zombies DragonRuby
