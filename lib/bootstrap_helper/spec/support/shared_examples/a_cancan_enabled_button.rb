shared_examples "a cancan enabled button" do |action|
  context "cancan" do
    before(:each) do
      AnlekBootstrapHelper.stub(:using_cancan?).and_return true
    end
    context "can" do
      before(:each) do
        helper.stub(:can?).with(action, Array.wrap(object).last).and_return(true)
      end
      it_behaves_like "a button"
    end
    context 'cannot' do
      before(:each) do
        helper.stub(:can?).with(action, Array.wrap(object).last).and_return(false)
      end
      it "renders nothing if can? returns false" do
        expect(subject).to be_blank
      end
    end
  end
end