require 'spec_helper'

describe NavItem do
  it { should validate_presence_of :name }
  it { should validate_presence_of :link }
end