class EmailsController < ApplicationController
  # before_action :authenticate_account
  # before_action :authorize_account

  # POST /emails/mail
  def mail
    emails = ['sammysparkles@gmail.com']
    
    emails.each {
      |email|

      AccountMailer.welcome_email(email).deliver_later
    }

    render(json: { message: 'Emails delivered!' })
  end
end
