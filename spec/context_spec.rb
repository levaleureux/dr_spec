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

      it 'generates the correct test_name' do
        test_name = caller[0].split(' ').last
        expect(test_name).to eq 'test_context_outer_context_1_inner_context_1_generates_the_correct_test_name'
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

      it 'generates the correct test_name' do
        test_name = caller[0].split(' ').last
        expect(test_name).to eq 'test_context_outer_context_2_inner_context_2_generates_the_correct_test_name'
      end
    end
  end
end