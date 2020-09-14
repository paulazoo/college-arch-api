class EmailsController < ApplicationController
  # before_action :authenticate_user
  # before_action :authorize_user

  # POST /emails/mail
  def mail
    emails = ['sammysparkles@gmail.com']
    
    emails.each {
      |email|

      UserMailer.welcome_email(email).deliver_later
    }

    render(json: { message: 'Emails delivered!' })
  end
end
