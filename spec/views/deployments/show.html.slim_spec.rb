require 'rails_helper'

RSpec.describe 'deployments/show', type: :view do
  let(:deployment) { FactoryGirl.create(:deployment) }
  before { assign(:deployment, deployment) }

  it 'renders attributes' do
    render
    expect(rendered).to match(/#{I18n.t("providers.#{deployment.provider_type}")}/)
    expect(rendered).to match(/#{deployment.region}/)
    expect(rendered).to match(/#{deployment.flavor}/)
  end
end
