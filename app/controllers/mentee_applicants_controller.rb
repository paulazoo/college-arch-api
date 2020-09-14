class MenteeApplicantsController < ApplicationController
  before_action :authenticate_user, only: %i[index]

  # GET /mentee_applicants
  def index
    if is_master
      @mentee_applicants = MenteeApplicant.all
      render(json: @mentee_applicants, status: :ok)
    else
      render(json: { message: 'You are not master' }, status: :unauthorized)
    end
  end

  # POST /mentee_applicants
  def create
    @mentee_applicant = MenteeApplicant.find_or_create_by(email: mentee_applicant_params[:email])

    @mentee_applicant.first_name = mentee_applicant_params[:first_name] if mentee_applicant_params[:first_name]
    @mentee_applicant.family_name = mentee_applicant_params[:family_name] if mentee_applicant_params[:family_name]
    # TODO finish other applicant attributes and add to allowed params

    if @mentee_applicant.save
      render(json: @mentee_applicant, status: :created)
    else
      render(json: @mentee_applicant.errors, status: :unprocessable_entity)
    end
  end

  private

  def set_mentor_applicant
    @mentor_applicant = MentorApplicant.find(params[:mentor_applicant_id])
  end

  def mentor_applicant_params
    params.permit([:email])
  end
end
