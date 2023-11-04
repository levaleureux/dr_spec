spec :context do
  context 'outer context 1' do
    before do
      @outer_context = 'outer context 1'
    end

    context 'inner context 1' do
      before do
        @inner_context = 'inner context 1'
      end

      it 'has correct inner context' do
        expect(@inner_context).to eq 'inner context 1'
      end
    end
  end

  context 'outer context 2' do
    before do
      @outer_context = 'outer context 2'
    end

    context 'inner context 2' do
      before do
        @inner_context = 'inner context 2'
      end

      it 'has correct inner context' do
        expect(@inner_context).to eq 'inner context 2'
      end
    end
  end
end