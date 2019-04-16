require File.expand_path '../spec_helper.rb', __FILE__

describe User do
  it { should have_property           :id }
  it { should have_property           :email }
  it { should have_property           :password }
end