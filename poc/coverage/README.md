# POC: Code Coverage pour DragonRuby/mruby

## Problème

mruby (utilisé par DragonRuby) n'a ni `Coverage`, ni `set_trace_func`, ni `TracePoint`. Les outils standard (SimpleCov) ne fonctionnent pas.

## Approche

Instrumentation ligne par ligne, comme Istanbul/nyc pour JavaScript :

1. Lire le source Ruby en texte
2. Injecter `__dr_cov(file, line);` avant chaque ligne exécutable
3. Eval le code instrumenté
4. Après les tests, compter les lignes touchées vs. les lignes exécutables

Le `;` sur la même ligne préserve les numéros de ligne dans les stack traces.

## Fichiers du POC

| Fichier | Rôle |
|---------|------|
| `sample_code.rb` | Code source exemple (classe SamplePlayer) |
| `poc_tracker.rb` | Compteur de hits par fichier/ligne |
| `poc_instrumenter.rb` | Transforme le source, classifie les lignes (sans Regexp) |
| `poc_test.rb` | Script de test end-to-end |

## Lancer le POC

```bash
ruby poc/coverage/poc_test.rb
```

## Résultat

```
== Coverage Report ==
 poc/coverage/sample_code.rb              84.6% (11/13 lines)
   Uncovered: 29, 33
------------------------------------------
 Total                                    84.6% (11/13 lines)
```

- 13 lignes exécutables détectées
- 11 couvertes (les méthodes appelées)
- 2 non couvertes : `move_down` (ligne 29) et `hit` (ligne 33) — volontairement non appelées

## Conclusions

1. **L'approche fonctionne** — le tracking ligne par ligne est correct
2. **Pas de Regexp nécessaire** — classification par `String#start_with?` et comparaisons
3. **Line numbers préservées** — le `;` évite de décaler les lignes
4. **Performance négligeable** — `__dr_cov` = simple incrémentation de hash

## Prochaine étape : intégration dans dr_spec

L'API utilisateur sera transparente (comme SimpleCov) :

```ruby
require "lib/dr_spec/dragon_specs.rb"

DrSpec::Coverage.start   # override require, instrumente les fichiers app/

require "app/component/game.rb"   # instrumenté automatiquement
require "spec/ball_spec.rb"        # pas instrumenté
require "spec/main_spec.rb"
```

Aucun changement au code du jeu.

## Issues liées

- #59 — Code coverage tracking (implémentation)
- #94 — Rapport HTML avec catégories de fichiers
- #95 — Rapport JSON pour CI
