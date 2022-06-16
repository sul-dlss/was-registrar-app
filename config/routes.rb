# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :collections, except: %i[destroy show] do
    post 'fetch', on: :member
    post 'retry', on: :member
  end

  resources :registration_jobs, only: %i[index create new]

  mount Sidekiq::Web => '/queues'
end
