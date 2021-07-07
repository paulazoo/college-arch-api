class MentorsController < ApplicationController
  before_action :authenticate_user, only: %i[create index batch]

  # GET /mentors
  def index
    if is_master
      @mentors = Mentor.all
      render(json: @mentors, status: :ok)
    else
      render(json: { message: 'You are not master' }, status: :unauthorized)
    end
  end

  # POST /mentors
  def create
    render(json: { message: 'You are not master' }, status: :unauthorized) if !is_master

    @user = User.find_by(email: mentor_params[:email])

    if @user.blank?
      @mentor = Mentor.new()

      @mentor.user = User.new(account: @mentor, email: mentor_params[:email])

      if @mentor.save
        Analytics.identify(
          user_id: @mentor.user.id.to_s,
          traits: {
            role: 'Mentor',
            user_id: @mentor.user.id.to_s,
            email: @mentor.user.email.to_s,
            name: @mentor.user.name.to_s,
            google_id: @mentor.user.google_id.to_s,
          },
        )

        render(json: @mentor.to_json, status: :created)
      else
        render(json: @mentor.errors, status: :unprocessable_entity)
      end

    else
      render(json: { message: 'User already exists!' })
    end
  end

  # POST /mentors/master
  def master
    render(json: { message: 'Wrong master creation password' }, status: :unauthorized) if mentor_params[:master_creation_password] != 'college_arch_master_creation_password'

    @user = User.find_by(email: mentor_params[:email])

    if @user.blank?
      @mentor = Mentor.new()

      @mentor.user = User.new(account: @mentor, email: mentor_params[:email])

      if @mentor.save
        Analytics.identify(
          user_id: @mentor.user.id.to_s,
          traits: {
            role: 'Mentor',
            user_id: @mentor.user.id.to_s,
            email: @mentor.user.email.to_s,
            name: @mentor.user.name.to_s,
            google_id: @mentor.user.google_id.to_s,
          },
        )

        render(json: @mentor.to_json, status: :created)
      else
        render(json: @mentor.errors, status: :unprocessable_entity)
      end

    else
      render(json: { message: 'User already exists!' })
    end
  end

  # POST /mentors/batch
  def batch
    render(json: { message: 'You are not master' }, status: :unauthorized) if !is_master

    parsed_emails = mentor_params[:batch_emails].split(", ")

    finished_mentors = []

    parsed_emails.each do |email|
      @user = User.find_by(email: email)

      if @user.blank?
        @mentor = Mentee.new()

        @mentor.user = User.new(account: @mentor, email: email)

        if @mentor.save
          Analytics.identify(
            user_id: @mentor.user.id.to_s,
            traits: {
              role: 'Mentee',
              user_id: @mentor.user.id.to_s,
              email: email,
            },
          )

          finished_mentors.push(@mentor)
        else
          puts @mentor.errors
        end

      else
        puts 'User already exists'
      end
    end

    render(json: { mentees: finished_mentors, status: :ok })
  end

  # POST mentors/view_unmatched
  def view_unmatched
    @unmatched_mentors = Mentor.where('id NOT IN (SELECT DISTINCT(mentor_id) FROM mentors_mentees)')
    return render(json: @unmatched_mentors.to_json(include: :user), status: :ok)
  end

  private

  def set_mentor
    @mentor = mentor.find(params[:id])
  end

  def mentor_params
    params.permit([:email, :batch_emails, :master_creation_password])
  end
end
