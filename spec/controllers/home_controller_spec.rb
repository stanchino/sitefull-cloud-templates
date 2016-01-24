require 'rails_helper'

describe HomeController, type: :controller do
  describe 'GET #index' do
    verify_success :index, 'home/index', 'application'
  end
end
