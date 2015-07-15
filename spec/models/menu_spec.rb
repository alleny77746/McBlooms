require 'spec_helper'

describe Menu do
  subject(:menu) { build :menu }
  it "is valid" do
    is_expected.to be_valid
  end
  let(:page) { FactoryGirl.create :page }
  it { is_expected.to validate_presence_of :title }

  describe "requires a link" do
    subject(:menu) { build :menu, page: nil, url: nil }
    it "to be provided" do
      is_expected.to_not be_valid
      expect(subject.errors).to include(:url)
    end
    it "to work if URL is provided" do
      subject.url = "http://google.com"
      expect(subject).to be_valid
    end
    it "to work if Page is provided" do
      subject.page = page
      expect(subject).to be_valid
    end
  end

  describe "link" do
    it "provides the URL if it's present" do
      url = "http://google.com"
      menu = FactoryGirl.build :menu, page: nil, url: url
      expect(menu.link).to eq url
    end
    it "provides the page object if it's present" do
      menu = FactoryGirl.build :menu, page: page, url: nil
      expect(menu.link).to eq page
    end
    it "provides th URL object if both url and page are present" do
      url = "http://testingisgreat.com"
      menu = FactoryGirl.build :menu, page: page, url: url
      expect(menu.link).to eq url
    end

  end

  describe "type" do
    it { is_expected.to validate_presence_of :type }
    it "only lets #{Menu::TYPES} to be assigned" do
      Menu::TYPES.each do |type|
        menu = FactoryGirl.build :menu, type: type
        expect(menu).to be_valid
      end
    end
    it "doesn't allow any other types" do
      %w(front_door content).each do |type|
        menu = FactoryGirl.build :menu, type: type
        expect(menu).to_not be_valid
      end
    end
    it "doesn't allow nil" do
      menu = FactoryGirl.build :menu, type: nil
      expect(menu).to_not be_valid
    end

    it "provides a readable collection" do
      menu_type = Menu::TYPES.first
      expect(Menu.type_collection).to include([menu_type.to_s.humanize, menu_type])
    end
  end

  describe "position" do
    it "defaults to 5" do
      menu = Menu.new()
      expect(menu.position).to be(5)
    end
  end
end
