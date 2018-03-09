Rails.application.routes.draw do
  namespace :admin do
  end
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "missions#index"

  resource :missions, only: [:index]

  namespace :admin do 
    root "missions#index"
    resource :missions
  end

end
