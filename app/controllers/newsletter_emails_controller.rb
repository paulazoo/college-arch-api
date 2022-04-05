class NewsletterEmailsController < ApplicationController
  before_action :authenticate_user, only: %i[index]

  # GET /newsletter_emails
  def index
    puts "starting index"
    if is_master
      puts "is master"
      @newsletter_emails = NewsletterEmail.all
      render(json: @newsletter_emails, status: :ok)
    else
      puts "not master"
      render(json: { message: 'You are not master' }, status: :unauthorized)
    end
  end

  # POST /newsletter_emails
  def create
    @newsletter_email = NewsletterEmail.find_or_create_by(email: newsletter_email_params[:email])

    if @newsletter_email.save
      render(json: @newsletter_email, status: :created)
    else
      render(json: @newsletter_email.errors, status: :unprocessable_entity)
    end
  end

  private

  def set_newsletter_email
    @newsletter_email = NewsletterEmail.find(params[:newsletter_email_id])
  end

  def newsletter_email_params
    params.permit([:email])
  end
end