require 'rails_helper'
require 'shared_examples/events_controller'

RSpec.describe 'EventController' do
  let(:template) { FactoryGirl.create(:template) }

  [:amazon, :azure, :google].each do |provider|
    describe "for #{provider}" do
      it_behaves_like 'controller that runs the deployment', provider
    end
  end
end
