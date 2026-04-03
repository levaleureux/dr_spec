# Dr Spec

A simple DSL and test runner DragonRuby Game Toolkit (DRGTK).
It try to mimic rspec.

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

### Using `smaug`

If you're using `smaug` to manage dependencies, you can install `dr_spec` by adding it to your `Smaug.toml`:

```toml
dr_spec = { repo = "https://github.com/levaleureux/dr_spec" }
```

Then simply run `smaug install` and add `require "smaug/dr_spec/lib/dr_spec/dragon_specs`
to your `app/main.rb` or `app/test.rb` file.

## Setup

Setting up and running your specs is easy. After you followed the installation instruction above, you're ready to create
your specs entrypoint file. This is normally `app/main.rb` or `app/test.rb`, but you can also have it in the `spec` folder if you prefer to keep it separate from your app code.

```ruby
# spec/main.rb
require "lib/dr_spec/dragon_specs.rb" # or if you're using smaug: require 'smaug/dr_spec/lib/dr_spec/dragon_specs'

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

**!🚧 ! NOTE check the implementation file as the doc is not 100% align with matchers
names yet**

dr_spec try to replicate some commonly used standard matchers in RSpec:

### Equality

`eq`: Verifies that two values are equal.
<!--
`eql`: Verifies that two values are equal, taking type into account.
## Numeric Comparison:
-->

1. be >, be >=: Verifies that a value is greater (or greater or equal) than
another.
1. be <, be <=: Verifies that a value is less (or less or equal) than another.

### Boolean

1. be_truthy: Verifies that a value evaluates to true in a boolean context.
1. be_falsey: Verifies that a value evaluates to false in a boolean context.
1. `be_nil` Verifies that a value evaluates to nil.

### Type

1. be_a(type) or be_an(type): Verifies that the object is an instance of the
specified type.
1. be_instance_of(type): Verifies that the object is an exact instance of the
specified type.

### Collection Content

1. include(element): Verifies that an element is included in a collection.
1. match_array(array): Verifies that the collection is equivalent to the specified
array.

### String

1. start_with(string): Verifies that a string starts with the specified text.
1. end_with(string): Verifies that a string ends with the specified text.
1. include(string): Verifies that a string contains the specified text.


## Outputs

There is on this project a will to make a very fast and readable output

<img src="image.png" alt="some output" width="300">


## Improve de doc

If you want to help on the doc of this project.
you can use grip to preview your markdown.

```
  pip install grip

```

```
  grip chemin/vers/votre/fichier.md

```
## Contributors

thanks to 
1. https://github.com/ekiru for the first PR.
1. https://github.com/terrainoob  for opening some issue.

## Thanks

This project was strongly inspired by
https://github.com/DragonRidersUnite/dragon_test

See
https://github.com/kfischer-okarin/roguelike-tutorial-2021/tree/main/game/tests
and
https://github.com/kfischer-okarin/sludge-n-cinder/tree/main/game/tests
for good complement

This project is pretty new, so if you want to improve the doc or add other test
helper. Feel free to open an issue and make a PR it will be apreciate.

