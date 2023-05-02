Rails.application.routes.draw do
  # testing
  post 'test' => 'users#test'

  # authentication and login
  post 'google_login' => 'users#google_login'
  post 'applicant_google_login' => 'users#applicant_google_login'
  post 'tokens/refresh' => 'tokens#refresh'

  # master
  put 'users/master_update' => 'users#master_update'

  # applications
  put 'users/applicant_update' => 'users#applicant_update'

  # rest api
  resources :users, only: [] do
    get 'events', on: :member
  end

  resources :users, only: %i[show update index]

  post 'mentors/batch' => 'mentors#batch'
  post 'mentors/master' => 'mentors#master'
  post 'mentors/master_accept' => 'mentors#master_accept'

  resources :mentors, only: %i[index create]

  resources :mentees, only: [] do
    post 'match', on: :member
    post 'unmatch', on: :member
  end

  post 'mentees/batch' => 'mentees#batch'
  post 'google_sheets/match_accepted' => 'google_sheets#match_accepted'

  resources :mentees, only: %i[index create]

  post 'mentees/view_unmatched' => 'mentees#view_unmatched'
  post 'mentors/view_unmatched' => 'mentors#view_unmatched'
  post 'mentees/view_matched' => 'mentees#view_matched'

  get 'events/public' => 'events#public'

  resources :events, only: [] do
    post 'register', on: :member
    post 'unregister', on: :member
    post 'public_register', on: :member
    post 'join', on: :member
    post 'public_join', on: :member
  end

  resources :events, only: %i[index create update destroy]

  resources :newsletter_emails, only: %i[index create]
  
  post 'google_sheets/import_mentee_mentor' => 'google_sheets#import_mentee_mentor'
  post 'google_sheets/import_events' => 'google_sheets#import_events'
  post 'google_sheets/export_registered' => 'google_sheets#export_registered'
  post 'google_sheets/export_joined' => 'google_sheets#export_joined'

  post 'emails/mail' => 'emails#mail'
  post 'emails/event_reminder' => 'emails#event_reminder'

  post 'mentee_applicants/accept' => 'mentee_applicants#accept'
  post 'mentor_applicants/accept' => 'mentor_applicants#accept'

  # editing through api
  post 'google_sheets/edit_table' => 'google_sheets#edit_table'

end
