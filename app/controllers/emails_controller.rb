class EmailsController < ApplicationController
  # before_action :authenticate_user
  # before_action :authorize_user

  # POST /emails/mail
  def mail
    emails = ['sammysparkles@gmail.com', 'paulazhu@college.harvard.edu']
    
    emails.each {
      |email|

      UserMailer.welcome_email(email).deliver_later
    }

    render(json: { message: 'Emails delivered!' })
  end

  # POST /emails/event_reminder
  def event_reminder
    # render(json: { message: 'You are not master' }, status: :unauthorized) unless is_master

    @event = Event.find(email_params[:event_id])
    render(json: { message: 'Event does not exist' }, status: :unprocessable_entity) if @event.blank?

    @registered = @event.registrations.where(registered: true)

    @registered.each{ |r|
      if !r.user.blank?
        UserMailer.event_reminder_email(
          r.user.email, 
          r.user.name, 
          @event.name, 
          @event.start_time.in_time_zone('Eastern Time (US & Canada)').to_s, 
          @event.end_time.in_time_zone('Eastern Time (US & Canada)').to_s,
          @event.link
        ).deliver_later
      else
        UserMailer.event_reminder_email(
          r.public_email, 
          r.public_name, 
          @event.name, 
          @event.start_time.in_time_zone('Eastern Time (US & Canada)').to_s, 
          @event.end_time.in_time_zone('Eastern Time (US & Canada)').to_s,
          @event.public_link
        ).deliver_later
      end
    }

    render(json: { message: 'Emails delivered!', event_reminder_email_params: [
      @event.name, 
      @event.start_time.in_time_zone('Eastern Time (US & Canada)').to_s, 
      @event.end_time.in_time_zone('Eastern Time (US & Canada)').to_s,
      @event.link
      ]})
  end

  private

  def email_params
    params.permit(:event_id)
  end

end
