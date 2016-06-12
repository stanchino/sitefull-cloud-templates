require 'rails_helper'

RSpec.describe Templates::ArgumentsController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/templates/1/arguments/new').to route_to('templates/arguments#new', template_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/templates/1/arguments/1/edit').to route_to('templates/arguments#edit', template_id: '1', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/templates/1/arguments/1').to route_to('templates/arguments#destroy', template_id: '1', id: '1')
    end
  end
end
