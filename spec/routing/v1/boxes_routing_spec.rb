# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::BoxesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/boxes').to route_to('v1/boxes#index')
    end

    it 'routes to #show' do
      expect(get: '/v1/boxes/1').to route_to('v1/boxes#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/v1/boxes').to route_to('v1/boxes#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/v1/boxes/1').to route_to('v1/boxes#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/v1/boxes/1').to route_to('v1/boxes#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/v1/boxes/1').to route_to('v1/boxes#destroy', id: '1')
    end
  end
end
