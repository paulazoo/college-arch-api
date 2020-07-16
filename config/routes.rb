Rails.application.routes.draw do

  get 'login' => 'accounts#login'

  resources :accounts, only: %i[show index]

  resources :accounts, param: :account_id do
    put 'update', on: :member
  end

  resources :mentors, only: %i[index create]

  resources :mentees, only: %i[index create]

  resources :newsletter_emails, only: %i[index create]
  
end
