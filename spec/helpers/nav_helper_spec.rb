require 'spec_helper'

describe NavHelper, type: :helper do
  before(:each) do
  end
  let(:nav1) { stub(name: "Nav1", link: "http://google.com", selected: nil) }
  let(:nav2) { stub(name: "Nav2", link: "http://yahoo.com", selected: nil) }
  let(:selected_nav) { stub(name: "selected", link:"/frank", selected: true) }
  let(:items) { [nav1, nav2] }

  context "generate_link" do
    it "works" do
      expect(generate_link(nav1)).to eq %Q{<li><a href="#{nav1.link}">#{nav1.name}</a></li>}
    end
    it "is selected" do
      expect(generate_link(selected_nav)).to eq %Q{<li class="active"><a href="#{selected_nav.link}">#{selected_nav.name}</a></li>}
    end
  end

  context "generate_nav" do
    it "returns a list of nav items" do
      expect(generate_nav(items)).to eq "<ul>#{generate_link(nav1)}#{generate_link(nav2)}</ul>"
    end
    it "returns a blank string if no nav items are passed" do
      expect(generate_nav([])).to be_nil
    end
  end

  context "sidenav" do
    context "nav_item" do
      let(:item) {FactoryGirl.create :category, name: "Beans"}
      it "returns nil without an item" do
        expect(nav_item(nil)).to be_nil
      end
      it "generates a valid nav item" do
        expect(nav_item(item)).to eq "<li><a href=\"/categories/beans\">#{item.name}</a></li>"
      end
      context "label" do
        it "can take a new label" do
          expect(nav_item(item, label: :id)).to eq "<li><a href=\"/categories/beans\">#{item.id}</a></li>"
        end
        it "can take a string label" do
          expect(nav_item(item, label: "cars")).to eq "<li><a href=\"/categories/beans\">cars</a></li>"
        end
      end
      context "href" do
        it "can take an href" do
          href = "/smallville"
          expect(nav_item(item, href: href)).to eq "<li><a href=\"#{href}\">#{item.name}</a></li>"
        end
      end
      context "match" do
        it "marks nav item active if match" do
          href = "/dogs"
          expect(nav_item(item, href: href, match: href)).to include(%Q{class="active"})
        end
        it "doesn't mark unmatched items " do
          href = "/dogs"
          expect(nav_item(item, href: href, match: "/cat")).to_not include(%Q{class="active"})
        end
      end

    end
    context "build_nav" do
      let(:item) {FactoryGirl.create :category, name: "Beans"}
      let(:item2) {FactoryGirl.create :category, name: "Cats"}
      it "returns nil if nil items" do
        expect(build_nav(nil)).to be_nil
      end
      it "returns nil if no items" do
        expect(build_nav([])).to be_nil
      end
      it "returns 1 nav item" do
        nav = build_nav([item, item2])
        expect(nav).to_not be_nil
        expect(nav).to eq "#{nav_item(item)}\n#{nav_item(item2)}"
      end
    end
  end

end