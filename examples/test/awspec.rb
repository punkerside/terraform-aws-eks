require 'awspec'

eks_name = `cd test/awspec/ && terraform output name`.strip.delete('"')

describe eks(eks_name.to_s) do
  it { should exist }
  it { should be_active }
end