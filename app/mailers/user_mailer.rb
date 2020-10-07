class UserMailer < ApplicationMailer
  default from: ENV['GMAIL_USERNAME']
 
  def welcome_email(email_address)
    @url  = 'http://collegearch.org/login'
    mail(to: email_address, subject: 'Welcome to College ARCH!')
  end

  def event_reminder_email(email_address, name, event_name, start_time, end_time, join_link)
    @name = name
    @event_name = event_name
    @start_time = start_time
    @end_time = end_time
    @join_link = join_link
    mail(to: email_address, subject: 'College ARCH Event: '+event_name+' 🎉')
  end
end
