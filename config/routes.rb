# frozen_string_literal: true

Squawker::Application.routes.draw do
  resources :sessions, only: %i[new create destroy]
  resources :relationships, only: %i[create destroy]
  resources :password_resets

  resources :users do
    member { get :following, :followers }
    member { get :feed }
    resources :likes, only: %i[index]
  end

  resources :squawks, only: %i[new show create destroy] do
    resources :likes, only: :index
    resource :likes, only: %i[create destroy]
  end

  root "static_pages#home"
  get "/home", to: "static_pages#home"
  get "/about", to: "static_pages#about"
  get "/signup", to: "users#new"
  get "/signin", to: "sessions#new"
  delete "/signout", to: "sessions#destroy"
  get "/trial", to: "sessions#trial"
  get "/search", to: "search#show"
  get "/activity_feed/index", to: "activity_feed#index"
end
