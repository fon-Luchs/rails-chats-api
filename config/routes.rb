Rails.application.routes.draw do
  resource :session, only: [:create, :destroy]
  resource :profile, only: [:create, :show] do
    resources :chats, only: [:index, :show, :create] do
      resources :messages, only: [:create, :index]
    end
  end
  resources :users, only: [:show, :index]
  post   'profile/chats/:id/add', to: 'chats#add'
  delete 'profile/chats/:id/leave', to: 'chats#leave'
end
