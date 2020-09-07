require 'awspec'
require 'aws-sdk'

eks_name = 'falcon-awspec'
project_tag = 'falcon'
env_tag = 'awspec'

describe eks(eks_name.to_s) do
  it { should exist }
  it { should be_active }
  it { should have_tag('Name').value(vpc_name.to_s) }
  it { should have_tag('Project').value(project_tag.to_s) }
  it { should have_tag('Env').value(env_tag.to_s) }
end