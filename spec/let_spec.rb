# Specs de `let` (#71) : valeur paresseuse, memoisee par test, surchargeable.

spec :let_syntax do
  let(:player) { { x: 0, y: 0 } }

  specify "expose la valeur du bloc" do
    expect(player[:x]).to eq 0
  end

  specify "memoise dans un meme test : meme objet a chaque appel" do
    snapshot = player
    snapshot[:x] = 99
    expect(player[:x]).to eq 99
  end

  specify "frais a chaque test : pas de fuite entre exemples" do
    expect(player[:x]).to eq 0
  end

  context "surcharge dans un contexte imbrique" do
    let(:player) { { x: 50, y: 0 } }

    specify "le let le plus interne gagne" do
      expect(player[:x]).to eq 50
    end
  end
end

spec :let_lazy do
  let(:trace)   { [] }
  let(:tracked) { trace << :hit; 42 }

  specify "paresse : le bloc n'est pas evalue tant qu'on ne l'appelle pas" do
    expect(trace).to eq []
    expect(tracked).to eq 42
    expect(trace).to eq [:hit]
  end

  specify "memoise : une seule evaluation meme appele deux fois" do
    tracked
    tracked
    expect(trace).to eq [:hit]
  end
end
