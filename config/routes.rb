Rails.application.routes.draw do
  
  # 管理者用
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
   sessions: "admin/sessions",
   passwords: "admin/passwords",
   registrations: "admin/registrations"
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :admin do
    root to: "homes#top"
    resources :genres, only: [:index, :create, :edit, :update]
    resources :items, except: [:destroy]
    resources :customers, only: [:index, :show, :edit, :update]
    resources :orders, only: [:show, :update] do
      patch "admin/order_details/:id" => "order_details#update", as: "order_details"
    end
  end

# 顧客用
  devise_for :customers, skip: [:passwords], controllers: {
   registrations: "public/registrations",
   sessions: 'public/sessions'
  }

  scope module: :customers do
  root to: "homes#top"
  get "about" => "homes#about"
  resources :items,only: [:index,:show]
  
  resource :customers,only: [:edit,:update,:show] do
    collection do
  	get 'quit'
  	patch 'out'
  	end
  end
  
  resources :cart_items, only: [:index, :update, :create, :destroy] do
      collection do
        delete 'destroy_all'
      end
    end
    
  resources :orders,only: [:new,:index,:show,:create] do
    collection do
    post 'confirm'
    get 'thanx'
    end
  end
  
    resources :addresses, except: [:show, :new]
  end

end
