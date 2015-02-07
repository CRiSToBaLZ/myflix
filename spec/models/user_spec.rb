require 'spec_helper'

User.destroy_all


describe User do
  it { should have_many(:reviews) }
  it { should have_many(:videos) }

end
