---
description: Run dr_spec tests with documentation format — shows the full spec tree with indented descriptions.
---

# Run dr_spec tests (doc format)

Run tests with the documentation reporter for a readable spec tree:

```bash
./dragonruby . --eval app/tests.rb --no-tick --doc
```

This outputs the full spec tree with indentation, like RSpec `--format documentation`.
