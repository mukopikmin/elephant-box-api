# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Foods::NoticesController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/v1/foods/1/notices').to route_to('v1/foods/notices#create', food_id: '1')
    end
  end
end
