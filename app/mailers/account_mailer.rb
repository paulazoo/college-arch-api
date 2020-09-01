class AccountMailer < ApplicationMailer
  default from: ENV['GMAIL_USERNAME']
 
  def welcome_email(email_address)
    @url  = 'http://collegearch.org/login'
    mail(to: email_address, subject: 'Welcome to College ARCH!')
  end
end
