Rails.application.routes.draw do
  resource :session, only: [:create, :destroy]
  resource :profile, only: [:create, :show]
  resources :users,  only: [:show]
  resources :chats
  resources :messages, only: [:create]
  post   'chat/add'
  delete 'chat/leave'
  get 'profile/chats'
end
