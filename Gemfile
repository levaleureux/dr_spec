# frozen_string_literal: true

source "https://rubygems.org"

# DragonRuby is a standalone runtime and does not use Bundler gems at runtime.
# This Gemfile is exclusively for linting, static analysis, and dev tooling.

group :development do
  gem "guard"
  gem "guard-shell"
  gem "lefthook", require: false
  gem "rubocop", require: false
  gem "reek", require: false
end

group :test do
  gem "rspec"
end
