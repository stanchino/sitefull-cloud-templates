require 'rails_helper'

describe HomeController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to be_success
      expect(response).to render_template 'home/index', layout: 'application'
    end
  end
end
