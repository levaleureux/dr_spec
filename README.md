# Dr Spec

A simple DSL and test runner DragonRuby Game Toolkit (DRGTK).
It try to mimic rspec.

🇫🇷 [Documentation en français](docs/fr/README.md)

[New to writing tests? Check out this tutorial introducing the concept in DRGTK!](https://www.dragonriders.community/recipes/testing)

🚧 **dr_spec is a work in progress! It works, but the interfaces may change.** 🚧

## dr_spec 2.0 — Transition Branch

The `dr_spec_2` branch is the **active development branch** for the next major version of dr_spec. It contains a full rewrite to a class-based architecture (replacing the previous closure-based approach) that fixes long-standing scope isolation issues.

### What's changing

- **Class-based architecture**: 2-pass system (Build → Run) with `World`, `ExampleGroup`, `Example`, `ExampleContext`
- **Proper test isolation**: Each test runs in its own fresh `ExampleContext` — no more shared state leaking between tests
- **Scope bug fix**: Resolves [#53](https://github.com/levaleureux/dr_spec/issues/53)

### Branch workflow during transition

```
feature/* ──→ dr_spec_2 ──→ develop ──→ master
              (staging)     (after community testing)
```

All new features and fixes target `dr_spec_2`. Once the community has validated the new architecture, `dr_spec_2` will be merged into `develop`, then released to `master`.

**Want to help test?** Check out the `dr_spec_2` branch and run the specs against your project. Feedback welcome via [issues](https://github.com/levaleureux/dr_spec/issues).

## Install

### Manually

1. copy `lib/dr_spec` folder into your dragon ruby project.
2. on your `app/main.rb` or `app/test.rb` file add `require "lib/dr_spec/dragon_specs.rb"` at the bottom of the file.

That's it! Now you can write specs for your app using `dr_spec`.

### Using Smaug

[Smaug](https://smaug.dev/) is the DragonRuby package manager. To install dr_spec via Smaug, add it to your project's `Smaug.toml`:

```toml
[dependencies]
dr_spec = { repo = "https://github.com/levaleureux/dr_spec" }
```

Then run:

```bash
smaug install
```

In your `app/main.rb` or `app/test.rb`, require dr_spec from the Smaug install path:

```ruby
require "smaug/dr_spec/lib/dr_spec/dragon_specs.rb"
```

All internal requires use `require_relative`, so dr_spec works correctly from the `smaug/` directory without any path issues.

## Setup

Setting up and running your specs is easy. After you followed the installation instruction above, you're ready to create
your specs entrypoint file. This is normally `app/main.rb` or `app/test.rb`, but you can also have it in the `spec` folder if you prefer to keep it separate from your app code.

```ruby
# spec/main.rb
require "lib/dr_spec/dragon_specs.rb" # or if you're using smaug: require "smaug/dr_spec/lib/dr_spec/dragon_specs.rb"

spec "Setup specs" do
  specify "works" do
    expect(true).to be_truthy
  end
end
```

## Running specs

### With manual install

If you have installed `dr_spec` manually into your dragonruby project, you should have the `dragonruby` executable in
the same project folder. To run the specs, simply run:

```bash
./dragonruby . --test spec/main.rb`
```

Remember to replace `spec/main.rb` if you chose a different spec's entrypoint file.

### With smaug

If you are using smaug, you can also use it to run specs:

```bash
smaug run --test spec/main.rb
```

### In CI (GitHub Actions)

DragonRuby is a commercial engine, so running tests in CI requires downloading the engine. Two options exist:

- [kfischer-okarin/download-dragonruby](https://github.com/kfischer-okarin/download-dragonruby) — downloads DR using your license (requires `DRAGONRUBY_ITCH_API_KEY` secret)
- [kfischer-okarin/dragonruby-for-ci](https://github.com/kfischer-okarin/dragonruby-for-ci) — open-source DR builds for CI (no license needed)

#### Key points

- **Headless mode**: Set `SDL_VIDEODRIVER=dummy` and `SDL_AUDIODRIVER=dummy` to run without a display
- **Exit code**: DragonRuby always returns 0 — use `--exit-on-fail` and check the output for failures
- **File conflicts**: Checkout your project in a subdirectory to avoid conflicts with files from the DR zip (e.g. `font.ttf`)

#### Example workflow

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:

jobs:
  test:
    name: dr_spec
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          path: project

      - name: Download DragonRuby
        uses: kfischer-okarin/download-dragonruby@v1
        with:
          version: 'latest'
          license_tier: 'standard'

      - name: Run dr_spec
        env:
          SDL_VIDEODRIVER: dummy
          SDL_AUDIODRIVER: dummy
        run: |
          chmod u+x ./dragonruby
          ./dragonruby project --eval app/tests.rb --no-tick --exit-on-fail 2>&1 | tee tests.log
          grep '0 ➖ test(s) failed' tests.log
```

You can also see dr_spec's own CI config as a working example: [`.github/workflows/ci.yml`](.github/workflows/ci.yml).

#### Generic CI (non-GitHub)

For any CI provider, the core commands are:

```bash
# Download and extract DragonRuby (adjust for your setup)
export SDL_VIDEODRIVER=dummy
export SDL_AUDIODRIVER=dummy
chmod u+x ./dragonruby
./dragonruby your-project --eval app/tests.rb --no-tick --exit-on-fail
```

## Usage

### Basic example

To describe your `spec` or `it` block you can use a :symbole or a "string" with any case or spaces.

```ruby
spec "Numeric Comparison matchers" do
  specify "be greater than" do |args, assert|
    expect(10).to be_greater_than 5
  end
  specify "be_greater_than_or_equal_to" do |args, assert|
    expect(10).to be_greater_than_or_equal_to 10
  end
  specify "be_less_than" do |args, assert|
    expect(5).to be_less_than 10
  end
  specify "be_less_than_or_equal_to" do |args, assert|
    expect(5).to be_less_than_or_equal_to 5
  end
end

# you can use symbol as spec and specify desc
#
spec :boolean_matchers do
  specify "be_truthy" do |args, assert|
    expect(true).to be_truthy
  end
  specify :be_falsy do |args, assert|
    expect(false).to be_falsy
  end
end

# You can use context before and after block
#
context "context_3" do
  before do
    @b = 5
  end
  specify "expectation_4" do |args, assert|
    puts "I'm the num 4"
    puts @a = @a * 5 + @b
    assert.equal! @a, 25, "nope 25"
  end
  after do |args, assert|
    @b = 6
    puts "after 4"
    @a = 4 * 5 + @b
    assert.equal! @a, 26, "nope 25"
  end
end

```

### Structure

1. spec
2. context
3. specify (replaces `it` for DR 6.x+ / Ruby 3.4 compatibility)
4. xspecify (pending, replaces `xit`)

> **Note:** `it` is a reserved keyword in Ruby 3.4+ (used by DragonRuby 6.x). Use `specify` instead. On older DR versions, `it` and `xit` are still available as aliases.

Like rspec. If you want to use this lib it's maybe because you already know
rspec. If you want more doc please open an issue ;)

## Matchers

dr_spec replicates commonly used RSpec matchers. All matchers support `to` and `not_to`, and accept an optional `fail_with:` parameter for custom error messages.

### Equality

| Matcher | Description |
|---------|-------------|
| `eq(expected)` | Verifies that two values are equal |

```ruby
expect(1 + 1).to eq 2
expect("foo").not_to eq "bar"
```

### Numeric Comparison

| Matcher | Description |
|---------|-------------|
| `be_greater_than(n)` | Verifies value > n |
| `be_greater_than_or_equal_to(n)` | Verifies value >= n |
| `be_less_than(n)` | Verifies value < n |
| `be_less_than_or_equal_to(n)` | Verifies value <= n |

```ruby
expect(10).to be_greater_than 5
expect(5).to be_less_than_or_equal_to 5
```

### Boolean

| Matcher | Description |
|---------|-------------|
| `be_truthy` | Verifies value is `true` |
| `be_falsy` | Verifies value is falsy (`false` or `nil`) |
| `be_nil` | Verifies value is `nil` |

```ruby
expect(true).to be_truthy
expect(nil).to be_nil
```

### Type

| Matcher | Description |
|---------|-------------|
| `be_instance_of(klass)` | Verifies exact class match |
| `be_kind_of(klass)` | Verifies class or ancestor match |

```ruby
expect("hello").to be_instance_of(String)
expect(1).to be_kind_of(Numeric)
```

### Collection

| Matcher | Description |
|---------|-------------|
| `include(element)` | Verifies collection includes element |
| `contain(element)` | Alias for `include` |
| `contain_exactly(array)` | Verifies collection has same elements (any order) |
| `include_elements_in_order(array)` | Verifies elements appear in order |
| `have_size(n)` | Verifies collection size |
| `be_empty` | Verifies collection is empty |

```ruby
expect([1, 2, 3]).to include 2
expect([3, 1, 2]).to contain_exactly [1, 2, 3]
expect([]).to be_empty
```

### String

| Matcher | Description |
|---------|-------------|
| `start_with(string)` | Verifies string starts with prefix |
| `end_with(string)` | Verifies string ends with suffix |
| ~~`match(regex)`~~ | Not available — mruby has no `Regexp` support |

```ruby
expect("hello world").to start_with "hello"
expect("hello world").to end_with "world"
```

### Error

| Matcher | Description |
|---------|-------------|
| `raise_error` | Verifies a block raises any error |
| `raise_error(ErrorClass)` | Verifies a block raises a specific error class |

```ruby
expect { raise "boom" }.to raise_error
expect { raise ArgumentError }.to raise_error(ArgumentError)
expect { 1 + 1 }.not_to raise_error
```

### Object

| Matcher | Description |
|---------|-------------|
| `respond_to(:method_name)` | Verifies object responds to a method |

```ruby
expect("hello").to respond_to(:length)
expect([1, 2]).to respond_to(:push)
```

### Custom

| Matcher | Description |
|---------|-------------|
| `satisfy { \|value\| ... }` | Verifies value satisfies a custom block |

```ruby
expect(10).to satisfy { |v| v > 5 }
expect(42).to satisfy { |v| v.even? && v > 10 }
```


## Code Coverage

dr_spec includes line-level code coverage for DragonRuby/mruby — something that standard Ruby tools (SimpleCov) can't do since mruby has no `Coverage` module.

### Quick start

Add one line before your requires:

```ruby
require "lib/dr_spec/dragon_specs.rb"

DrSpec::Coverage.start           # instruments app/ files automatically

require "app/component/ball.rb"  # instrumented (tracked)
require "app/component/game.rb"  # instrumented (tracked)
require "spec/ball_spec.rb"      # NOT instrumented
require "spec/main_spec.rb"
```

No changes to your game code. The coverage report is printed automatically after `run_specs`:

```
== Coverage Report ==
 app/component/ball.rb       85.7% (12/14 lines)
   Uncovered: 23, 47
 app/component/game.rb       100.0% (18/18 lines)
------------------------------------------
 Total                       93.8% (30/32 lines)
```

### Custom track path

By default, `Coverage.start` instruments files starting with `"app/"`. You can change this:

```ruby
DrSpec::Coverage.start("lib/my_lib/")  # only instrument lib/my_lib/ files
```

### How it works

dr_spec uses Istanbul/nyc-style source instrumentation:

1. `Coverage.start` overrides `require` to intercept matching files
2. Each intercepted file is read, and a `__dr_cov(file, line)` call is injected before each executable line
3. The instrumented code is written to a temporary file in `tmp/` and loaded via the original `require`
4. After tests run, the tracker reports which lines were executed

### Temporary files

Coverage generates temporary instrumented files in the `tmp/` directory of your project (e.g. `tmp/coverage_app_component_ball.rb`). These files are created during test runs and can be safely deleted. Add `tmp/` to your `.gitignore`:

```
tmp/
```

### Limitations

- **Line coverage only** — no branch coverage (would require an AST parser)
- **No automatic file discovery** — mruby has no `Dir.glob`, files must be loaded via `require`
- **No Regexp** — mruby doesn't include Regexp; the instrumenter uses string comparisons

## Output formats

dr_spec ships with 3 built-in reporters. Pass a CLI flag or use `run_specs(reporter:)`.

### Dots (default)

Compact output, one character per test:

```bash
./dragonruby . --eval app/tests.rb --no-tick
```

```
..........F..P..
100 ✅ test(s) passed
 2 🔀 test(s) pending
 1 ❌ test(s) failed
```

### Doc (`--doc`)

RSpec-style documentation with indented spec tree:

```bash
./dragonruby . --eval app/tests.rb --no-tick --doc
```

```
string_matchers
  ✅ start_with
  ✅ end_with
architecture
  example_group
    tree construction
      ✅ ExampleGroup has children and parent
      ✅ full_description concatenates ancestor descriptions
  scope_isolation
    each it block gets its own ExampleContext
      ✅ first test increments counter

100 passed, 2 pending
```

### Quiet (`--quiet`)

Minimal output for CI scripts:

```bash
./dragonruby . --eval app/tests.rb --no-tick --quiet
```

```
dr_spec: 100 test(s) passed
```

### Programmatic usage

```ruby
run_specs(reporter: DrSpec::Reporters::Doc.new)
run_specs(reporter: DrSpec::Reporters::Quiet.new)
```

## Using with AI agents (Claude Code, etc.)

When running dr_spec from an AI agent, use `--quiet` to minimize token usage:

```bash
./dragonruby . --eval app/tests.rb --no-tick --quiet --exit-on-fail
```

This outputs a single line (`dr_spec: 100 test(s) passed`) instead of listing every test. The `--exit-on-fail` flag writes failures to `test-failures.txt` for the agent to read only when needed.

### Claude Code skills

This repo includes Claude Code skills in `.claude/skills/`:

| Skill | Description |
|-------|-------------|
| `/dr-spec` | Run tests in quiet mode (recommended for AI) |
| `/dr-spec-doc` | Run tests with documentation format |

These are available automatically when working in the project with Claude Code.

## Contributing

### Branch strategy (git flow)

This project uses [git flow](https://danielkummer.github.io/git-flow-cheatsheet/):

| Branch | Role |
|--------|------|
| `master` | Stable releases only |
| `develop` | Main development branch |
| `feature/*` | Feature branches, created from `develop` |

### How to contribute

1. Fork the repo
2. Create a feature branch from `develop`:
   ```bash
   git checkout -b feature/my-feature origin/develop
   ```
3. Write your code and tests
4. Push and open a PR targeting `develop`

**Never commit directly to `master`.** All changes go through `feature/* → develop → master`.

### Preview docs locally

```bash
pip install grip
grip README.md
```

## Contributors

Thanks to:
1. https://github.com/ekiru for the first PR
2. https://github.com/terrainoob for opening some issues

## Acknowledgements

This project was strongly inspired by [dragon_test](https://github.com/DragonRidersUnite/dragon_test).

See also:
- [kfischer-okarin/roguelike-tutorial-2021](https://github.com/kfischer-okarin/roguelike-tutorial-2021/tree/main/game/tests)
- [kfischer-okarin/sludge-n-cinder](https://github.com/kfischer-okarin/sludge-n-cinder/tree/main/game/tests)

