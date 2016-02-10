require 'rails_helper'

RSpec.describe 'deployments/new', type: :view do
  let(:template) { FactoryGirl.create(:template) }
  let(:deployment) { FactoryGirl.build(:deployment, template: template) }
  before do
    assign(:template, template)
    assign(:deployment, deployment)
  end

  it 'renders new deployment form' do
    render

    assert_select 'form[action=?][method=?]', template_deployments_path(template), 'post' do
      Deployment::PROVIDERS.each do |provider|
        assert_select "input#deployment_provider_#{provider}[name=?]", 'deployment[provider]'
      end

      # assert_select 'input#deployment_credentials[name=?]', 'deployment[credentials]'

      # assert_select 'input#deployment_image[name=?]', 'deployment[image]'

      # assert_select 'input#deployment_flavor[name=?]', 'deployment[flavor]'
    end
  end
end
