require 'spec_helper'

describe Ingredient do
  subject(:ingredient) { build :ingredient }
  it { should validate_presence_of :name }
  it { expect(subject.key).to_not be }
  it "has an possible image" do
    expect(subject.image).to be_an_instance_of IngredientImageUploader
  end
end
