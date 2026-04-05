# Code Coverage

dr_spec inclut un outil de couverture de code ligne par ligne pour DragonRuby/mruby. Les outils Ruby standard (SimpleCov) ne fonctionnent pas car mruby n'a pas de module `Coverage` natif.

## Demarrage rapide

Ajoutez une seule ligne avant vos requires :

```ruby
require "lib/dr_spec/dragon_specs.rb"

DrSpec::Coverage.start           # instrumente les fichiers app/ automatiquement

require "app/component/ball.rb"  # instrumenté (suivi)
require "app/component/game.rb"  # instrumenté (suivi)
require "spec/ball_spec.rb"      # NON instrumenté
require "spec/main_spec.rb"
```

Aucune modification de votre code de jeu n'est necessaire. Le rapport de couverture est affiche automatiquement apres `run_specs` :

```
== Coverage Report ==
 app/component/ball.rb       85.7% (12/14 lines)
   Uncovered: 23, 47
 app/component/game.rb       100.0% (18/18 lines)
------------------------------------------
 Total                       93.8% (30/32 lines)
```

## Chemin de suivi personnalise

Par defaut, `Coverage.start` instrumente les fichiers dont le chemin commence par `"app/"`. Vous pouvez changer ce prefixe :

```ruby
DrSpec::Coverage.start("lib/my_lib/")  # instrumente uniquement lib/my_lib/
```

## Comment ca fonctionne

dr_spec utilise une instrumentation de source de type Istanbul/nyc :

1. `Coverage.start` surcharge `require` pour intercepter les fichiers correspondants
2. Chaque fichier intercepte est lu, et un appel `__dr_cov(file, line)` est injecte avant chaque ligne executable
3. Le code instrumente est ecrit dans un fichier temporaire dans `tmp/` et charge via le `require` original
4. Apres l'execution des tests, le tracker affiche quelles lignes ont ete executees

## Fichiers temporaires

La couverture genere des fichiers instrumentes temporaires dans le repertoire `tmp/` de votre projet (par exemple `tmp/coverage_app_component_ball.rb`). Ces fichiers sont crees pendant l'execution des tests et peuvent etre supprimes en toute securite. Ajoutez `tmp/` a votre `.gitignore` :

```
tmp/
```

## Limitations

- **Couverture de lignes uniquement** — pas de couverture de branches (cela necessiterait un parseur AST)
- **Pas de decouverte automatique de fichiers** — mruby n'a pas de `Dir.glob`, les fichiers doivent etre charges via `require`
- **Pas de Regexp** — mruby n'inclut pas Regexp ; l'instrumenteur utilise des comparaisons de chaines

## Voir aussi

- [Guide d'utilisation](guide_utilisation.md) — installation et syntaxe
- [README principal (EN)](../../README.md#code-coverage) — documentation anglaise
