# Architecture de dr_spec

## Vue d'ensemble

dr_spec utilise une architecture **2-pass class-based** pour construire et exécuter les tests.

```
Phase 1 (Build)                    Phase 2 (Run)
================                   ============
spec "foo" do                      World.build_test_methods!
  context "bar" do        →          → define_method(:test_foo_bar_baz)
    it "baz" do ... end              → chaque test crée un ExampleContext frais
  end
end
```

## Classes

### DrSpec::World (singleton)

Registre central. Accumule les ExampleGroup (via `register_group`) et les shared_examples (via `register_shared`). Gère une pile `@group_stack` pour le DSL imbriqué.

`build_test_methods!` parcourt l'arbre en DFS et appelle `Object.define_method` pour chaque Example.

### DrSpec::ExampleGroup

Noeud de l'arbre. Représente un `spec` ou `context` block.

- `@parent` : lien vers le groupe parent (nil pour les racines)
- `@children` : sous-groupes
- `@examples` : tests `it`/`xit`
- `@before_blocks`, `@after_blocks` : hooks

Méthodes clés :
- `collected_befores` : remonte la chaîne parent → enfant, retourne tous les befores dans l'ordre
- `collected_afters` : inverse (enfant → parent)
- `full_description` : concaténation des descriptions de la chaîne ancêtre
- `each_example` : itérateur DFS sur tous les examples

### DrSpec::Example

Feuille de l'arbre. Représente un `it` ou `xit` block.

- `test_method_name` : nom snake_case pour `define_method`
- `run(args, assert)` : crée un ExampleContext frais et exécute befores → it → afters dessus

### DrSpec::ExampleContext

Objet d'exécution isolé pour chaque test. Fournit `expect(subject)`.

Point critique : `Example#run` crée une **sous-classe anonyme** (`Class.new(ExampleContext)`) pour que les `def` dans les `before` blocks ne polluent pas les autres tests.

```ruby
def run(args, assert)
  ctx_class = Class.new(DrSpec::ExampleContext)
  ctx = ctx_class.new(assert)
  group.collected_befores.each { |b| ctx.instance_exec(args, assert, &b) }
  ctx.instance_exec(args, assert, &@block) unless pending?
  group.collected_afters.each  { |a| ctx.instance_exec(args, assert, &a) }
end
```

### DrSpec::Metadata

Encapsule les données de filtrage (`:focus`, `:tags`). Immutable via `#merge` qui retourne une nouvelle instance.

### DrSpec::Configuration

Configuration globale minimale : `format_mode`, `log_level`.

## DSL (core/dsl.rb)

Fonctions top-level qui délèguent vers `DrSpec::World.instance` :

| Fonction | Action |
|----------|--------|
| `spec(name, metadata, &block)` | Crée un ExampleGroup racine, register + push/yield/pop |
| `focus_spec(name, metadata, &block)` | Comme `spec` avec `focus: true` |
| `context(description, &block)` | Crée un ExampleGroup enfant |
| `it(message, &block)` | Crée un Example dans le groupe courant |
| `xit(message, &block)` | Crée un Example pending |
| `before(&block)` / `after(&block)` | Ajoute un hook au groupe courant |
| `shared_examples(name, &block)` | Construit et enregistre un ExampleGroup |
| `it_behaves_like(name)` | Copie le shared dans un sous-contexte |
| `include_examples(name)` | Fusionne le shared dans le contexte courant |

## Isolation des scopes (fix #53)

Chaque `it` block s'exécute dans son propre `ExampleContext` (sous-classe anonyme). Cela garantit :
- Les `@variables` d'instance ne fuient pas entre tests
- Les `def method_name` dans les `before` blocks ne polluent pas les autres groupes
- Les afters d'un contexte enfant n'affectent pas les tests d'un contexte parent
