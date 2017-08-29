require 'rails_helper'

RSpec.describe AuthenticationController, type: :routing do
  describe 'routing' do
    it 'routes to #local' do
      expect(post: '/auth/local').to route_to('authentication#local')
    end

    it 'routes to #google' do
      expect(get: '/auth/google/callback').to route_to('authentication#google')
    end

    it 'routes to #google_token' do
      expect(get: '/auth/google/token').to route_to('authentication#google_token')
    end

    it 'routes to #auth0' do
      expect(get: '/auth/auth0/callback').to route_to('authentication#auth0')
    end
  end
end
