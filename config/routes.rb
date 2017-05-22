# frozen_string_literal: true

Squawker::Application.routes.draw do
  resources :password_resets
  resources :recommendations, only: %i[index]
  resources :relationships, only: %i[create destroy]
  resources :sessions, only: %i[new create destroy]
  resources :squawks, only: %i[new show create destroy] do
    resources :likes, only: :index
    resource :likes, only: %i[create destroy]
    resource :flags, only: %i[create destroy]
  end
  resources :usernames, only: %i[index]
  resources :users, except: %i[index] do
    member { get :following, :followers }
    member { get :feed }
    resources :likes, only: %i[index]
  end

  root "static_pages#home"
  get "/home", to: "static_pages#home"
  get "/about", to: "static_pages#about"
  get "/signup", to: "users#new"
  get "/signin", to: "sessions#new"
  delete "/signout", to: "sessions#destroy"
  get "/trial", to: "sessions#trial"
  get "/search", to: "search#show"
  get "/activity-feed", to: "activity_feed#index"
end
