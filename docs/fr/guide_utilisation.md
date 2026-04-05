# Guide d'utilisation

## Installation

### Manuellement

1. Copiez le dossier `lib/dr_spec` dans votre projet DragonRuby
2. Dans votre `app/main.rb` ou `app/test.rb`, ajoutez :

```ruby
require "lib/dr_spec/dragon_specs.rb"
```

### Avec Smaug

Ajoutez dans votre `Smaug.toml` :

```toml
dr_spec = { repo = "https://github.com/levaleureux/dr_spec" }
```

Puis `smaug install` et :

```ruby
require "smaug/dr_spec/lib/dr_spec/dragon_specs"
```

## Lancer les tests

### En local

```bash
./dragonruby . --eval app/tests.rb --no-tick
```

### Avec Smaug

```bash
smaug run --test spec/main.rb
```

### En CI

Voir la section [CI du README principal](../../README.md#in-ci-github-actions).

## Syntaxe de base

### spec et context

`spec` définit un groupe de tests. `context` crée un sous-groupe pour organiser les cas de test.

```ruby
spec "MonObjet" do
  context "quand il est initialisé" do
    specify "a une valeur par défaut" do
      expect(MonObjet.new.valeur).to eq 0
    end
  end
end
```

Les descriptions acceptent des `:symboles` ou des `"strings"`.

### specify

`specify` (alias de `it`) définit un test individuel.

```ruby
specify "additionne deux nombres" do
  expect(2 + 3).to eq 5
end
```

> **Note :** `it` est un mot réservé en Ruby 3.4+ (DragonRuby 6.x). Utilisez `specify` à la place.

### xspecify (test en attente)

Préfixez avec `x` pour marquer un test comme pending (il ne sera pas exécuté) :

```ruby
xspecify "fonctionnalité future" do
  expect(true).to eq true
end
```

### focus_spec

Pour n'exécuter qu'un seul groupe de tests pendant le développement :

```ruby
focus_spec "mon test en cours" do
  specify "ce que je debugge" do
    expect(1).to eq 1
  end
end
```

## Hooks : before et after

`before` s'exécute avant chaque test du groupe. `after` s'exécute après. Ils sont hérités par les contextes enfants.

```ruby
spec "avec hooks" do
  before do
    @joueur = Joueur.new
  end

  specify "le joueur existe" do
    expect(@joueur).not_to be_nil
  end

  context "après un mouvement" do
    before do
      @joueur.move(10, 0)
    end

    specify "la position x change" do
      expect(@joueur.x).to eq 10
    end
  end

  after do
    # nettoyage si nécessaire
  end
end
```

L'ordre d'exécution : befores du parent → befores de l'enfant → test → afters de l'enfant → afters du parent.

## Assertions : expect / to / not_to

```ruby
expect(valeur).to matcher
expect(valeur).not_to matcher
```

### Chaînage avec .and

```ruby
expect(10)
  .to(eq 10)
  .and
  .to(be_greater_than 5)
```

### Message d'erreur personnalisé

Tous les matchers acceptent `fail_with:` :

```ruby
expect(score).to eq 100, fail_with: "le score devrait être 100"
```

## Blocs (pour raise_error)

Pour tester les erreurs, passez un bloc à `expect` :

```ruby
expect { methode_dangereuse }.to raise_error
expect { 1 + 1 }.not_to raise_error
```

## Formats de sortie (reporters)

dr_spec propose 3 reporters integres. Passez un flag CLI ou utilisez `run_specs(reporter:)`.

### Dots (par defaut)

Sortie compacte, un caractere par test :

```bash
./dragonruby . --eval app/tests.rb --no-tick
```

```
..........F..P..
100 ✅ test(s) passed
 2 🔀 test(s) pending
 1 ❌ test(s) failed
```

### Doc (`--doc`)

Format documentation avec arbre indente des specs, similaire a RSpec :

```bash
./dragonruby . --eval app/tests.rb --no-tick --doc
```

```
string_matchers
  ✅ start_with
  ✅ end_with
architecture
  example_group
    tree construction
      ✅ ExampleGroup has children and parent
      ✅ full_description concatenates ancestor descriptions

100 passed, 2 pending
```

### Quiet (`--quiet`)

Sortie minimale pour les scripts CI et les agents IA :

```bash
./dragonruby . --eval app/tests.rb --no-tick --quiet
```

```
dr_spec: 100 test(s) passed
```

### Usage programmatique

```ruby
run_specs(reporter: DrSpec::Reporters::Doc.new)
run_specs(reporter: DrSpec::Reporters::Quiet.new)
```

## Utilisation avec les agents IA (Claude Code, etc.)

Pour executer dr_spec depuis un agent IA, utilisez `--quiet` pour minimiser la consommation de tokens :

```bash
./dragonruby . --eval app/tests.rb --no-tick --quiet --exit-on-fail
```

Cela affiche une seule ligne (`dr_spec: 100 test(s) passed`) au lieu de lister chaque test. Le flag `--exit-on-fail` ecrit les echecs dans `test-failures.txt` pour que l'agent puisse les lire uniquement en cas de besoin.

### Skills Claude Code

Ce repo inclut des skills Claude Code dans `.claude/skills/` :

| Skill | Description |
|-------|-------------|
| `/dr-spec` | Lancer les tests en mode quiet (recommande pour l'IA) |
| `/dr-spec-doc` | Lancer les tests avec le format documentation |

Ces skills sont disponibles automatiquement lorsque vous travaillez dans le projet avec Claude Code.

## Code Coverage

dr_spec inclut un outil de couverture de code ligne par ligne. Voir la [documentation dediee](coverage.md).

```ruby
DrSpec::Coverage.start
require "app/mon_fichier.rb"  # instrumente automatiquement
```

## Limitations DragonRuby / mruby

DragonRuby utilise mruby, pas CRuby. Quelques différences importantes :

- **Pas de Regexp** : `Regexp` n'existe pas dans mruby. Le matcher `match` (regex) n'est pas utilisable. N'ecrivez pas de tests avec `/pattern/`.
- **`it` est reserve** : en Ruby 3.4+ (DragonRuby 6.x), `it` est un mot-cle. Utilisez `specify` a la place.
- **Pas de `Dir.glob`** : mruby n'a pas de decouverte automatique de fichiers. Chaque fichier de test doit etre charge explicitement via `require`.
- **Pas de `Coverage`** : le module standard Ruby `Coverage` n'existe pas en mruby. dr_spec fournit sa propre solution via `DrSpec::Coverage` (voir [coverage.md](coverage.md)).

## Voir aussi

- [Matchers](matchers.md) — reference complete
- [Shared Examples](shared_examples.md) — factoriser les tests
- [Code Coverage](coverage.md) — couverture de code
- [Guide de migration v1 vers v2 (EN)](../MIGRATION-v2.md) — mise a jour vers la nouvelle architecture
