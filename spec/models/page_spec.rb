require 'spec_helper'

describe Page do
  subject(:page) { FactoryGirl.build :page }
  it { should validate_presence_of :title }
  it { should validate_presence_of :content }

  describe "create menu for page" do
    it "works" do
      page.menu_type = Menu::TYPES.first
      expect{page.save}.to change(Menu, :count).by(1)  
    end
  end
end
