# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root to: 'collections#index'
  get '/', to: redirect('/collections')

  resources :collections, only: %i[index show]
end
