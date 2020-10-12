require 'awspec'

eks_name = 'falcon-awspec'

describe eks(eks_name.to_s) do
  it { should exist }
  it { should be_active }
end