require 'spec_helper'

describe Product do
  subject(:product) { FactoryGirl.build :product }
  it { should validate_presence_of :sku }
  it { should validate_uniqueness_of :sku }

  it { should validate_presence_of :name }
end
