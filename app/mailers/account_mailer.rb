class AccountMailer < ApplicationMailer
  default from: ENV['GMAIL_USERNAME']
 
  def welcome_email()
    @url  = 'http://collegearch.org/login'
    mail(to: 'collegearch@gmail.com', subject: 'Welcome to College ARCH!')
  end
end
