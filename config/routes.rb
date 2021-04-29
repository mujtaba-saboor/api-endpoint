# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :it_assets, only: %i[create update index show] do
        collection do
          # add if needed else remove
        end
        member do
          # add if needed else remove
        end
      end
    end
  end

  match '/*path', controller: 'api/v1/errors', action: 'error_four_zero_four', via: :all
  root to: 'api/v1/errors#error_four_zero_four', via: :all
end
