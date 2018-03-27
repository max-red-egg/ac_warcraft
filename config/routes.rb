Rails.application.routes.draw do
  namespace :admin do
    get 'instances/index'
  end
  namespace :admin do
  end
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "missions#my_mission"

  resources :notifications do
    collection do
      post :mark_as_checked_all
      post :mark_as_read_all
    end
    member do
      post :mark_as_read      
    end
  end
  resources :invitations, only: [:index, :show] do
    member do
      post :accept
      post :decline
      post :cancel
    end
    resources :invite_msgs, only: [:create]
  end
  resources :instances, only: [:index, :show,:edit] do
    member do
      post :submit
      patch :submit  #任務完成，提交答案
      post :save
      post :cancel   #取消組隊
      post :abort    #放棄任務
    end

    collection do
      get :history
    end

    resources :instance_msgs, only: [:create]
  end

  resources :followships, only: [:create, :destroy]

  resources :missions, only: [:index, :show] do
    member do
      get :my_mission
      post :challenge
      
      get :select_user
      # POST challenge_mission_path 挑戰本任務
    end

    collection do
      get :teaming
    end
  end

  resources :reviews, only: [:index, :show] do
    member do
      patch :submit
    end
  end

  resources :users do
    member do
      post :invite
    end

    collection do
      get :following
      get :follower
    end
  end

  namespace :admin do
    root "missions#index"
    resources :missions
    resources :instances, only: [:index]
  end

end
