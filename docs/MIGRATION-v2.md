# Migration guide: dr_spec v1 → v2

## Overview

dr_spec v2 is a full rewrite from a closure-based architecture to a class-based 2-pass system. The main benefit is proper test isolation — each test runs in its own `ExampleContext`, fixing scope leak issues (#53).

This guide covers what you need to change in your project to upgrade.

## Step 1: Replace `lib/dr_spec/`

Delete your existing `lib/dr_spec/` folder and copy the v2 version from the dr_spec repository (`dr_spec_2` branch).

The internal file structure has changed significantly. v1 files like `core.rb`, `core/blocks.rb`, `core/shared_example.rb`, and `core/patch.rb` no longer exist. You don't need to worry about this — just replace the whole folder.

## Step 2: Update your test entry point

Your entry point (`app/tests.rb` or similar) should look like this:

```ruby
require "lib/dr_spec/dragon_specs.rb"

require "spec/my_spec.rb"
# ... other spec files ...
require "spec/main_spec.rb"  # must contain: run_specs
```

If your `main_spec.rb` previously contained `$gtk.tests.start`, replace it with just:

```ruby
run_specs
```

## Step 3: Remove block parameters

v1 used `do |args, assert|` signatures everywhere. v2 no longer requires them.

### before / after blocks

```ruby
# v1
before do |args, assert|
  @player = Player.new
end

# v2
before do
  @player = Player.new
end
```

### Test blocks (it / specify)

```ruby
# v1
it "has a position" do |args, assert|
  expect(@player.x).to eq 0
end

# v2
specify "has a position" do
  expect(@player.x).to eq 0
end
```

> **Tip:** You can keep `|args, assert|` in block signatures — they will be ignored. But removing them is cleaner.

## Step 4: Replace `it` with `specify`

DragonRuby 6.x uses Ruby 3.4+ where `it` is a reserved keyword. Use `specify` instead:

```ruby
# v1
it "works" do
  expect(true).to be_truthy
end

# v2
specify "works" do
  expect(true).to be_truthy
end
```

`xit` becomes `xspecify` for pending tests.

> **Note:** On older DragonRuby versions (< 6.x), `it` and `xit` still work as aliases.

## Step 5: Replace `assert.equal!` calls

If you used the DragonRuby native `assert` object, replace with `expect`:

```ruby
# v1
assert.equal! @score, 10, "score should be 10"

# v2
expect(@score).to eq 10, fail_with: "score should be 10"
```

## Step 6: Verify `expect` usage

The `expect().to` API is the same in v1 and v2. No changes needed for:

```ruby
expect(value).to eq expected
expect(value).not_to eq other
expect(value).to(eq 1).and.to(be_greater_than 0)
```

### New in v2: block support for `expect`

v2 adds support for blocks, enabling `raise_error`:

```ruby
expect { dangerous_method }.to raise_error
expect { dangerous_method }.to raise_error(ArgumentError)
```

## Step 7: New matchers available

v2 adds these matchers (optional to use):

| Matcher | Description |
|---------|-------------|
| `raise_error` / `raise_error(ErrorClass)` | Verify a block raises an error |
| `respond_to(:method)` | Verify an object responds to a method |
| `satisfy { \|v\| ... }` | Verify a custom condition |

## Quick migration checklist

- [ ] Replace `lib/dr_spec/` with v2
- [ ] Update test entry point to use `run_specs`
- [ ] Remove `|args, assert|` from block signatures (or leave them — they're ignored)
- [ ] Replace `it` → `specify`, `xit` → `xspecify`
- [ ] Replace `assert.equal!` → `expect().to eq`
- [ ] Run tests and fix any remaining issues

## Limitations

- **No Regexp**: DragonRuby/mruby does not include `Regexp`. The `match` matcher exists but cannot be used.
- **`it` is reserved**: Use `specify` on DragonRuby 6.x+.
