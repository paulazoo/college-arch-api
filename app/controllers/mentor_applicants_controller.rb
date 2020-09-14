class MentorApplicantsController < ApplicationController
  before_action :authenticate_account, only: %i[index]

  # GET /mentor_applicants
  def index
    if is_master
      @mentor_applicants = MentorApplicant.all
      render(json: @mentor_applicants, status: :ok)
    else
      render(json: { message: 'You are not master' }, status: :unauthorized)
    end
  end

  # POST /mentor_applicants
  def create
    @mentor_applicant = MentorApplicant.find_or_create_by(email: mentor_applicant_params[:email])
    
    # TODO finish other applicant attributes and add to allowed params

    if @mentor_applicant.save
      render(json: @mentor_applicant, status: :created)
    else
      render(json: @mentor_applicant.errors, status: :unprocessable_entity)
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
