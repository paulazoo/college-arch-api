class MenteeApplicantsController < ApplicationController
  before_action :authenticate_user, only: %i[index show update accept]
  before_action :set_mentee_applicant, only: %i[show update]

  # GET /mentee_applicants
  def index
    return render(json: { message: 'You are not master' }, status: :unauthorized) unless is_master

    @mentee_applicants = MenteeApplicant.all
    render(json: @mentee_applicants, status: :ok)
  end

  private

  def set_mentee_applicant
    @mentee_applicant = MenteeApplicant.find(params[:id])
  end

  def mentee_applicant_params
    params.permit([:mentee_applicant_id, \
      :email, :phone, :first_name, :family_name, :grad_year, \
      :state, :country, :us_living, :city, \
      :school, :essay, \
      :first_gen, :low_income, :stem_girl, :single_parent, :disabled, :lgbt, \
      :black, :hispanic, :asian, :pi, :me_na, :native, :immigrant, :undoc, \
      :hobby, :extra_component, \
      :interests, \
      :applicant_password, :applicant_status ])
  end
end
