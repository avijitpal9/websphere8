require 'spec_helper'
describe 'websphere8' do
  context 'with default values for all parameters' do
    it { should contain_class('websphere8') }
  end
end
