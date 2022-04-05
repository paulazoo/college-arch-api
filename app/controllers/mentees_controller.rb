class MenteesController < ApplicationController
  before_action :authenticate_user, only: %i[create index match unmatch batch]
  before_action :set_mentee, only: %i[match unmatch]

  # GET /mentees
  def index
    if is_master
      @mentees = Mentee.all
      render(json: @mentees.to_json(include: [:user, mentor: { include: :user }]))
    else
      render(json: { message: 'You are not master' }, status: :unauthorized)
    end
  end

  # POST /mentees
  def create
    render(json: { message: 'You are not master' }, status: :unauthorized) if !is_master

    @user = User.find_by(email: mentee_params[:email])

    if @user.blank?
      @mentee = Mentee.new()

      @mentee.user = User.new(account: @mentee, email: mentee_params[:email])

      if @mentee.save
        render(json: @mentee.to_json, status: :created)
      else
        render(json: @mentee.errors, status: :unprocessable_entity)
      end

    else
      render(json: { message: 'User already exists' })
    end
  end

  # POST /mentees/:mentee_id/match
  def match
    render(json: { message: 'You are not master' }, status: :unauthorized) if !is_master

    @mentee = Mentee.find(mentee_params[:mentee_id])
    render(json: { message: 'Mentee does not exist' }) if @mentee.blank?

    @mentor = Mentor.find(mentee_params[:mentor_id])
    render(json: { message: 'Mentor does not exist'}) if @mentor.blank?

    @mentor.mentees << @mentee

    if @mentor.save
      render(json: { mentee: @mentee, mentor: @mentor }, status: :created)
    else
      render(json: @mentor.errors, status: :unprocessable_entity)
    end
  end

  # POST /mentees/:mentee_id/unmatch
  def unmatch
    render(json: { message: 'You are not master' }, status: :unauthorized) if !is_master

    @mentee = Mentee.find(mentee_params[:mentee_id])
    render(json: { message: 'Mentee does not exist' }) if @mentee.blank?

    @mentor = Mentor.find(mentee_params[:mentor_id])
    render(json: { message: 'Mentor does not exist'}) if @mentor.blank?

    @mentors_mentee = MentorsMentee.find_by(mentor: @mentor, mentee: @mentee)
    render(json: { message: 'Not matched' }) if @mentors_mentee.blank?

    @mentors_mentee.destroy
    render(json: { message: 'Succesfully deleted' }, status: :ok)
  end

  # POST /mentees/batch
  def batch
    render(json: { message: 'You are not master' }, status: :unauthorized) if !is_master

    parsed_emails = mentee_params[:batch_emails].split(", ")

    finished_mentees = []

    parsed_emails.each do |email|
      @user = User.find_by(email: email)

      if @user.blank?
        @mentee = Mentee.new()

        @mentee.user = User.new(account: @mentee, email: email)

        if @mentee.save
          finished_mentees.push(@mentee)
        else
          puts @mentee.errors
        end

      else
        puts 'User already exists'
      end
    end

    render(json: { mentees: finished_mentees, status: :ok })
  end

  # POST mentees/view_unmatched
  def view_unmatched
    @unmatched_mentees = Mentee.where('id NOT IN (SELECT DISTINCT(mentee_id) FROM mentors_mentees)')
    return render(json: @unmatched_mentees.to_json(include: :user), status: :ok)
  end

  # POST mentees/view_matched
  def view_matched
    @matched_mentees = Mentee.where('id IN (SELECT DISTINCT(mentee_id) FROM mentors_mentees)')
    
    @mentee_emails = ''
    @mentor_emails = ''
    @together_emails = ''
    
    @matched_mentees.each {
      |m|
      @mentee_emails = @mentee_emails + m.user.email + ','
      @mentor_emails = @mentor_emails + m.mentor.user.email + ','
      @together_emails = @together_emails + m.user.email + ":" + m.mentor.user.email + ','
    }
    render(json: { mentee_emails: @mentee_emails, mentor_emails: @mentor_emails, together_emails: @together_emails}, status: :ok)
  end
  
  private

  def set_mentee
    @mentee = Mentee.find(params[:id])
  end

  def mentee_params
    params.permit([:email, :mentee_id, :mentor_id, :batch_emails ])
  end
end
