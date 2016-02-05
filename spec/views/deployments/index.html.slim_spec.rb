require 'rails_helper'

RSpec.describe 'deployments/index', type: :view do
  let(:template) { FactoryGirl.create(:template) }
  let(:deployments) { FactoryGirl.create_list(:deployment, 2, template: template) }

  before do
    assign(:template, template)
    assign(:deployments, deployments)
  end

  it 'renders a list of deployments' do
    render
    deployments.each do |deployment|
      assert_select 'tr>td', text: deployment.provider
      assert_select 'tr>td', text: deployment.image
      assert_select 'tr>td', text: deployment.flavor
    end
  end
end
