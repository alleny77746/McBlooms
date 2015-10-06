require "spec_helper"

describe AnlekBootstrapHelper::ListGroupHelper do
  subject(:result) do
    helper.tb_list_group do |list|
      list.item "this is an item"
    end
  end

  it "renders list group object" do
    expect(subject).to have_css(".list-group")
  end
end