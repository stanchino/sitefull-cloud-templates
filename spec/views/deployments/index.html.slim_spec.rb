# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'deployments/index', type: :view do
  let(:template) { stub_model(Template, os: 'debian') }
  let(:deployments) { Array.new(2) { stub_model(Deployment, template: template) } }

  before do
    assign(:template, template)
    assign(:deployments, deployments)
  end

  it 'renders a list of deployments' do
    render
    deployments.each do |deployment|
      assert_select 'tr>td', text: deployment.region
      assert_select 'tr>td', text: deployment.machine_type
    end
  end
end
