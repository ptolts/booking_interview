Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'index#index'

  resources :index, only: []  do
    collection do
      get '/', to: "index#index"
    end
  end

  resources :apartment, only: []  do
    collection do
      post '/all', to: "apartment#all"
    end
  end  

  resources :booking, only: []  do
    collection do
      post '/check_availability', to: "booking#check_availability"
      post '/all', to: "booking#all"
      post '/book', to: "booking#book"
    end
  end    

end
