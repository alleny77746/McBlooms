require 'spec_helper'

describe Size do
  it { should validate_presence_of :amount}
  it { should validate_presence_of :unit}
end
