Rails.application.routes.draw do
  get "contacts/new"
  get "contacts/create"
  devise_for :users
  root "tasks#index"

  resources :tasks
  
  # show を追加して、個別のご褒美画面を表示できるようにします
  resources :rewards, only: [:index, :show, :create, :destroy]
  resources :contacts, only: [:new, :create]
  # マイページ
  get 'mypage', to: 'users#show', as: :user_mypage

  # ルーレット関連
  # resources ではなく resource (単数系) を使っている現在の設定を維持します
  resource :roulette, only: [:show], controller: 'roulettes' do
    post :spin, on: :collection
  end

  # Rails標準の設定
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
