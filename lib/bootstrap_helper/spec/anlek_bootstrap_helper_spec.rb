require "spec_helper"

describe AnlekBootstrapHelper do
  context 'using_cancan?' do
   it "is false without CanCan loaded" do
     expect(AnlekBootstrapHelper.using_cancan?).to be_false
   end
   it "is true" do
    stub_const("CanCan", Object.new)
    expect(AnlekBootstrapHelper.using_cancan?).to be_true
   end
  end

end