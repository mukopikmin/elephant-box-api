# frozen_string_literal: true

Rails.application.routes.draw do
  api_version(module: 'V1', path: { value: 'v1' }, default: true) do
    root 'root#index'

    resources :units

    resources :foods do
      member do
        get :versions
        get :image
        put :revert
      end
    end

    resources :boxes do
      collection do
        get :owns
        get :invited
      end

      member do
        get :versions
        get :foods
        get :units
        get :image
        post :invite
        put :revert
        delete 'invite' => :uninvite
      end
    end

    resources :users do
      collection do
        get :verify
        get :search
      end

      member do
        get :avatar
      end
    end

    post 'auth/local', to: 'authentication#local'
    get 'auth/google/callback', to: 'authentication#google'
    get 'auth/google/token', to: 'authentication#google_token'
    get 'auth/auth0/callback', to: 'authentication#auth0'
    get 'auth/failure', to: 'authentication#failure'
  end
end
