# Shared Examples

Les shared examples permettent de factoriser des tests réutilisables entre plusieurs contextes.

## Définir des shared examples

```ruby
shared_examples "un objet avec des coordonnées" do
  specify "a un x" do
    expect(@objet.x).not_to be_nil
  end

  specify "a un y" do
    expect(@objet.y).not_to be_nil
  end
end
```

## it_behaves_like

Crée un sous-contexte qui inclut les shared examples. Les tests apparaissent dans un contexte nommé d'après le shared.

```ruby
spec "Point" do
  before do
    @objet = Point.new(10, 20)
  end

  it_behaves_like "un objet avec des coordonnées"
end

spec "Joueur" do
  before do
    @objet = Joueur.new(0, 0)
  end

  it_behaves_like "un objet avec des coordonnées"
end
```

Output :

```
✅ test_Point_un objet avec des coordonnées_a un x
✅ test_Point_un objet avec des coordonnées_a un y
✅ test_Joueur_un objet avec des coordonnées_a un x
✅ test_Joueur_un objet avec des coordonnées_a un y
```

## include_examples

Fusionne les shared examples directement dans le contexte courant (sans créer de sous-contexte).

```ruby
spec "Widget" do
  before do
    @objet = Widget.new(5, 5)
  end

  include_examples "un objet avec des coordonnées"

  specify "a une taille" do
    expect(@objet.size).to be_greater_than 0
  end
end
```

Output :

```
✅ test_Widget_a un x
✅ test_Widget_a un y
✅ test_Widget_a une taille
```

## it_behaves_like vs include_examples

| | `it_behaves_like` | `include_examples` |
|---|---|---|
| Crée un sous-contexte | Oui | Non |
| Isolation | Les tests sont dans leur propre groupe | Les tests sont au même niveau |
| Output | Préfixé par le nom du shared | Directement dans le contexte parent |

En général, préférez `it_behaves_like` pour la clarté de l'output. Utilisez `include_examples` quand vous voulez que les tests apparaissent au même niveau que les autres tests du contexte.

## Exemple complet

```ruby
shared_examples "un conteneur" do
  specify "n'est pas vide" do
    expect(@conteneur).not_to be_empty
  end

  specify "a une taille" do
    expect(@conteneur).to respond_to(:size)
  end
end

spec "Array comme conteneur" do
  before do
    @conteneur = [1, 2, 3]
  end

  it_behaves_like "un conteneur"

  specify "supporte push" do
    expect(@conteneur).to respond_to(:push)
  end
end
```
