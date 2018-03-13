Rails.application.routes.draw do
  namespace :admin do
  end
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "missions#index"

  resources :instances, only: [:show, :create]
  
  resources :missions, only: [:index, :show] do
    member do
      post :challenge
      # POST challenge_mission_path 挑戰本任務
    end
  end

  resources :users

  namespace :admin do 
    root "missions#index"
    resources :missions
  end

end
