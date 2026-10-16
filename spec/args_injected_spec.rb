# Implicit `args` (#125): every example receives the real DragonRuby args
# ($gtk.args) through its ExampleContext, so a spec can drive the real
# tick(args) and inject inputs (keyboard.key_down.set, mouse.click, text).
spec :args_injected do
  specify "args is the real $gtk.args" do
    expect(args).to eq($gtk.args)
  end

  specify "args is available in before hooks" do
    seen = nil
    group = DrSpec::ExampleGroup.new("g")
    group.add_before { |a| seen = a }
    example = DrSpec::Example.new("e", group: group, block: proc {})
    example.run($gtk.args)
    expect(seen).to eq($gtk.args)
  end

  specify "a let(:args) overrides the injected args" do
    ctx = DrSpec::ExampleContext.new
    ctx.args = :injected
    expect(ctx.args).to eq(:injected)
  end

  specify "an input set on args is visible to the next tick-driven code" do
    args.inputs.keyboard.key_down.set([:tab], true)
    expect(args.inputs.keyboard.key_down.truthy_keys).to include(:tab)
    args.inputs.keyboard.key_down.clear
  end
end
