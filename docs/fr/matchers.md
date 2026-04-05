# Référence des Matchers

Tous les matchers supportent `to` et `not_to`, et acceptent un paramètre optionnel `fail_with:` pour personnaliser le message d'erreur.

## Égalité

| Matcher | Description | Source |
|---------|-------------|--------|
| `eq(expected)` | Vérifie l'égalité (`==`) | `matchers/matchers.rb` |

```ruby
expect(1 + 1).to eq 2
expect("foo").not_to eq "bar"
```

## Comparaison numérique

| Matcher | Description | Source |
|---------|-------------|--------|
| `be_greater_than(n)` | Vérifie `> n` | `matchers/numeric_comparison_matchers.rb` |
| `be_greater_than_or_equal_to(n)` | Vérifie `>= n` | |
| `be_less_than(n)` | Vérifie `< n` | |
| `be_less_than_or_equal_to(n)` | Vérifie `<= n` | |

```ruby
expect(10).to be_greater_than 5
expect(5).to be_less_than_or_equal_to 5
```

## Booléens

| Matcher | Description | Source |
|---------|-------------|--------|
| `be_truthy` | Vérifie que la valeur est `true` | `matchers/boolean_matchers.rb` |
| `be_falsy` | Vérifie que la valeur est falsy (`false` ou `nil`) | |
| `be_nil` | Vérifie que la valeur est `nil` | |

```ruby
expect(true).to be_truthy
expect(nil).to be_nil
expect(false).to be_falsy
```

## Type

| Matcher | Description | Source |
|---------|-------------|--------|
| `be_instance_of(klass)` | Vérifie la classe exacte | `matchers/type_matchers.rb` |
| `be_kind_of(klass)` | Vérifie la classe ou un ancêtre | |

```ruby
expect("hello").to be_instance_of(String)
expect(1).to be_kind_of(Numeric)
```

## Collection

| Matcher | Description | Source |
|---------|-------------|--------|
| `include(element)` | Vérifie qu'un élément est présent | `matchers/collection_matchers.rb` |
| `contain(element)` | Alias de `include` | |
| `contain_exactly(array)` | Vérifie les mêmes éléments (ordre quelconque) | |
| `include_elements_in_order(array)` | Vérifie les éléments dans l'ordre | |
| `have_size(n)` | Vérifie la taille | |
| `be_empty` | Vérifie que la collection est vide | |

```ruby
expect([1, 2, 3]).to include 2
expect([3, 1, 2]).to contain_exactly [1, 2, 3]
expect([1, 2, 3]).to include_elements_in_order [1, 2]
expect([1, 2]).to have_size 2
expect([]).to be_empty
```

## String

| Matcher | Description | Source |
|---------|-------------|--------|
| `start_with(string)` | Vérifie le préfixe | `matchers/string_matchers.rb` |
| `end_with(string)` | Vérifie le suffixe | |
| ~~`match(regex)`~~ | Non disponible — mruby n'a pas de support `Regexp` | |

> **Attention** : Le matcher `match` (regex) n'est **pas utilisable** dans DragonRuby. mruby n'inclut pas `Regexp` par défaut. Ce matcher existe dans le code source mais ne peut pas être appelé.

```ruby
expect("hello world").to start_with "hello"
expect("hello world").to end_with "world"
# match(/regex/) — NON DISPONIBLE dans DragonRuby (pas de Regexp en mruby)
```

## Erreur

| Matcher | Description | Source |
|---------|-------------|--------|
| `raise_error` | Vérifie qu'un bloc lève une erreur | `matchers/error_matchers.rb` |
| `raise_error(ErrorClass)` | Vérifie le type d'erreur | |

Nécessite un bloc avec `expect { ... }` :

```ruby
expect { raise "boom" }.to raise_error
expect { raise ArgumentError, "bad" }.to raise_error(ArgumentError)
expect { 1 + 1 }.not_to raise_error
```

## Objet

| Matcher | Description | Source |
|---------|-------------|--------|
| `respond_to(:method_name)` | Vérifie qu'un objet répond à une méthode | `matchers/object_matchers.rb` |

```ruby
expect("hello").to respond_to(:length)
expect([1, 2]).to respond_to(:push)
```

## Custom

| Matcher | Description | Source |
|---------|-------------|--------|
| `satisfy { \|v\| ... }` | Vérifie une condition personnalisée via un bloc | `matchers/satisfy_matcher.rb` |

```ruby
expect(10).to satisfy { |v| v > 5 }
expect(42).to satisfy { |v| v.even? && v > 10 }
```

## Créer son propre matcher

Héritez de `CoreMatcher` et implémentez `positive_match?(actual)` :

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

Utilisez-le ensuite comme n'importe quel matcher :

```ruby
expect(valeur).to mon_matcher(42)
```
