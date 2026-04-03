# Roadmap

## Implémenté

- [x] DSL RSpec-like : `spec`, `context`, `specify`, `before`, `after`
- [x] Architecture class-based 2-pass (fix scope isolation #53)
- [x] Matchers : `eq`, booléens, numériques, string, collection, type, error, object, satisfy
- [x] Shared examples : `shared_examples`, `it_behaves_like`, `include_examples`
- [x] `xspecify` (tests pending)
- [x] `focus_spec` (exécuter un seul groupe)
- [x] Chaînage `.and` pour les assertions
- [x] `fail_with:` messages personnalisés
- [x] Output formaté avec couleurs ANSI
- [x] Tick-based testing (simulation de ticks DragonRuby)
- [x] CI GitHub Actions

## En cours

- [ ] Tags et filtrage ([#7](https://github.com/levaleureux/dr_spec/issues/7)) — `metadata.rb` commencé
- [ ] Doc reporter format ([#72](https://github.com/levaleureux/dr_spec/issues/72))

## Prévu

- [ ] Syntaxe `let` ([#71](https://github.com/levaleureux/dr_spec/issues/71))
- [ ] Mocking d'objets ([#4](https://github.com/levaleureux/dr_spec/issues/4))
- [ ] Agrégation des failures ([#8](https://github.com/levaleureux/dr_spec/issues/8))
- [ ] Logging / rerun des tests échoués ([#6](https://github.com/levaleureux/dr_spec/issues/6))
- [ ] Code coverage ([#59](https://github.com/levaleureux/dr_spec/issues/59))
- [ ] Compatibilité Smaug ([#78](https://github.com/levaleureux/dr_spec/issues/78))

## Vision long terme

- [ ] Scenario runner Capybara-like ([#58](https://github.com/levaleureux/dr_spec/issues/58))
- [ ] Syntaxe BDD/Gherkin Turnip-like ([#57](https://github.com/levaleureux/dr_spec/issues/57))
- [ ] Simulation d'inputs ([#69](https://github.com/levaleureux/dr_spec/issues/69))

## Comment contribuer

1. Forkez le repo
2. Créez une branche `feature/xxx` depuis `dr_spec_2`
3. Développez avec des tests
4. Ouvrez une PR vers `dr_spec_2`

Les issues marquées comme ouvertes sont un bon point de départ. Voir les [issues sur GitHub](https://github.com/levaleureux/dr_spec/issues).
