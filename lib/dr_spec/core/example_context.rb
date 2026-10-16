module DrSpec
  class ExampleContext
    # `args` implicite (#125) : un VRAI args DragonRuby ($gtk.args) injecte par le
    # runner, disponible dans tout specify/let/before SANS le declarer. Permet des
    # tests qui pilotent tick(args) et assertent sur args.outputs (rendu/input)
    # avec le vrai runtime. Un `let(:args)` du spec le surcharge si besoin.
    attr_accessor :args

    def expect(subject = nil, &block)
      Expectation.new(subject, &block)
    end
  end
end
