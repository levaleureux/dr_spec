---
description: Run the dr_spec test suite. Use --quiet for minimal output (recommended for AI agents to save tokens).
---

# Run dr_spec tests

Run the test suite. Use `--quiet` for minimal output (ideal for AI agents):

```bash
./dragonruby . --eval app/tests.rb --no-tick --quiet --exit-on-fail
```

If tests fail, read `test-failures.txt` for failure details.

## Other output formats

- **Dots** (default): `./dragonruby . --eval app/tests.rb --no-tick`
- **Doc** (indented spec tree): `./dragonruby . --eval app/tests.rb --no-tick --doc`
- **Quiet** (one line, best for AI): `./dragonruby . --eval app/tests.rb --no-tick --quiet`

## With coverage

Add `DrSpec::Coverage.start` before your `require` statements in `app/tests.rb` to enable line-level coverage. Reports are generated automatically (console + JSON + HTML).
