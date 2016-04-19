require 'rails_helper'
#require 'shared_examples/events_controller'

RSpec.describe EventController, type: :controller do
  login_user

  let(:template) { FactoryGirl.create(:template, user: user) }

  [:amazon, :azure, :google].each do |provider|
    describe "for #{provider}" do
      #it_behaves_like 'events controller', provider
    end
  end
end
