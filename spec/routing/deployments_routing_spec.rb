# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DeploymentsController, type: :routing do
  describe 'routing' do
    let(:template) { stub_model(Template) }

    it 'routes to #all' do
      expect(get: '/deployments').to route_to('deployments#all')
    end

    it 'routes to #index' do
      expect(get: "/templates/#{template.id}/deployments").to route_to_action 'index'
    end

    it 'routes to #new' do
      expect(get: "/templates/#{template.id}/deployments/new").to route_to_action 'new'
    end

    it 'routes to #create' do
      expect(post: "/templates/#{template.id}/deployments").to route_to_action 'create'
    end

    it 'routes to #show' do
      expect(get: '/deployments/1').to route_to('deployments#show', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: "/templates/#{template.id}/deployments/1").to route_to('deployments#destroy', template_id: template.id.to_s, id: '1')
    end

    def route_to_action(action)
      route_to("deployments##{action}", template_id: template.id.to_s)
    end
  end
end
