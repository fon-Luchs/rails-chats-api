Rails.application.routes.draw do
  resource :session, only: [:create, :destroy]
  resource :profile, only: [:create, :show]
  resources :users,  only: [:show]
  resources :chats do
    resources :messages, only: [:create, :index]
  end
  post   'chat/add'
  delete 'chat/leave'
  get 'profile/chats'
end
