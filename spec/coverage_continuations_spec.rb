# Durcissement de l'instrumenteur de couverture (#113).
#
# Batterie d'EQUIVALENCE SEMANTIQUE : on instrumente une fixture ou chaque
# methode est une expression coupee par une forme de continuation differente,
# on `eval` le resultat, et on verifie que chaque methode renvoie EXACTEMENT la
# meme valeur que l'original. Un __dr_cov insere au milieu d'une expression
# detourne sa valeur de retour (ou casse la syntaxe) -> la valeur differe.
#
# Gardes structurels en complement : __dr_cov absent des lignes de continuation,
# et PRESENT apres un predicat (anti-faux-positif du heuristique ternaire).
spec "coverage instrumentation - durcissement des continuations (#113)" do
  before do
    DrSpec::Coverage::Tracker.reset
    @tracker = DrSpec::Coverage::Tracker.instance
    @instrumenter = DrSpec::Coverage::Instrumenter.new
    @file = "spec/fixtures/continuations.rb"
    @source = $gtk.read_file(@file)
  end

  specify "le code instrumente renvoie les MEMES valeurs que l'original" do
    eval(@instrumenter.instrument(@source, @file, @tracker))
    got = {
      and_op: ContinuationsFixture.and_op, or_op: ContinuationsFixture.or_op,
      arith: ContinuationsFixture.arith, comma: ContinuationsFixture.comma,
      chain: ContinuationsFixture.chain, safe_chain: ContinuationsFixture.safe_chain,
      ternary: ContinuationsFixture.ternary, kw_and: ContinuationsFixture.kw_and,
      kw_or: ContinuationsFixture.kw_or, backslash: ContinuationsFixture.backslash
    }
    expect(got).to eq(and_op: false, or_op: true, arith: 60, comma: 6, chain: 12,
                       safe_chain: 9, ternary: 100, kw_and: false, kw_or: true, backslash: 6)
  end

  specify "ternaire : la ligne valeur (cond ?) n'est pas instrumentee" do
    out = @instrumenter.instrument("x = ok ?\n  win :\n  lose\n", @file, @tracker)
    line = out.split("\n").select { |l| l.include?("win") }.first
    expect(line.include?("__dr_cov")).to eq false
  end

  specify "chaine a point en tete : la ligne .map n'est pas instrumentee" do
    out = @instrumenter.instrument("base\n  .map { |x| x }\n", @file, @tracker)
    line = out.split("\n").select { |l| l.include?(".map") }.first
    expect(line.include?("__dr_cov")).to eq false
  end

  specify "mot-cle and/or : la ligne de continuation n'est pas instrumentee" do
    out = @instrumenter.instrument("keep and\n  more\n", @file, @tracker)
    line = out.split("\n").select { |l| l.strip == "more" }.first
    expect(line.include?("__dr_cov")).to eq false
  end

  specify "predicat (empty?) en fin de ligne : la ligne suivante reste instrumentee" do
    out = @instrumenter.instrument("arr.empty?\nresult = compute\n", @file, @tracker)
    line = out.split("\n").select { |l| l.include?("result = compute") }.first
    expect(line.include?("__dr_cov")).to eq true
  end
end
