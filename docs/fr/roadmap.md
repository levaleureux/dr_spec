# Roadmap

## Implemente

- [x] DSL RSpec-like : `spec`, `context`, `specify`, `before`, `after`
- [x] Architecture class-based 2-pass (fix scope isolation #53)
- [x] Matchers : `eq`, booleens, numeriques, string, collection, type, error, object, satisfy
- [x] Shared examples : `shared_examples`, `it_behaves_like`, `include_examples`
- [x] `xspecify` (tests pending)
- [x] `focus_spec` (executer un seul groupe)
- [x] Chainage `.and` pour les assertions
- [x] `fail_with:` messages personnalises
- [x] Output formate avec couleurs ANSI
- [x] Tick-based testing (simulation de ticks DragonRuby)
- [x] CI GitHub Actions
- [x] Code coverage ligne par ligne ([#59](https://github.com/levaleureux/dr_spec/issues/59)) — `DrSpec::Coverage.start`, rapports console/JSON/HTML
- [x] Doc reporter format ([#72](https://github.com/levaleureux/dr_spec/issues/72)) — `--doc` pour un arbre indente des specs
- [x] Quiet reporter — `--quiet` pour sortie minimale (CI, agents IA)
- [x] Matchers `raise_error`, `respond_to`, `satisfy`
- [x] Support agents IA (Claude Code skills `/dr-spec`, `/dr-spec-doc`)

## En cours

- [ ] Tags et filtrage ([#7](https://github.com/levaleureux/dr_spec/issues/7)) — `metadata.rb` commence

## Prevu

- [ ] Syntaxe `let` ([#71](https://github.com/levaleureux/dr_spec/issues/71))
- [ ] Mocking d'objets ([#4](https://github.com/levaleureux/dr_spec/issues/4))
- [ ] Agregation des failures ([#8](https://github.com/levaleureux/dr_spec/issues/8))
- [ ] Logging / rerun des tests echoues ([#6](https://github.com/levaleureux/dr_spec/issues/6))
- [ ] Compatibilite Smaug ([#78](https://github.com/levaleureux/dr_spec/issues/78))

## Vision long terme

- [ ] Scenario runner Capybara-like ([#58](https://github.com/levaleureux/dr_spec/issues/58))
- [ ] Syntaxe BDD/Gherkin Turnip-like ([#57](https://github.com/levaleureux/dr_spec/issues/57))
- [ ] Simulation d'inputs ([#69](https://github.com/levaleureux/dr_spec/issues/69))

## Comment contribuer

1. Forkez le repo
2. Creez une branche `feature/xxx` depuis `develop`
3. Developpez avec des tests
4. Ouvrez une PR vers `develop`

Les issues marquees comme ouvertes sont un bon point de depart. Voir les [issues sur GitHub](https://github.com/levaleureux/dr_spec/issues).
