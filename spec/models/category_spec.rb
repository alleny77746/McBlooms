require 'spec_helper'

describe Category do
  subject(:cateogry) { FactoryGirl.build(:category) }
  it { expect(subject).to be_valid }

  it { should validate_presence_of :name }

  it "should have a slug" do
    subject.name = "the big Product"
    subject.save!
    expect(subject.slug).to eq "the-big-product"
  end

  it "should default position to 5" do
    expect(Category.new.position).to eq 5
  end

end
