require 'rails_helper'
require 'shared_examples/controllers'

describe HomeController, type: :controller do
  describe 'GET #index' do
    it_behaves_like 'successful GET action', :index, 'home/index', 'application'
  end
end
