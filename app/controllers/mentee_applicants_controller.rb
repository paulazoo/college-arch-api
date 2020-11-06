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
    @mentee_applicant.city = mentee_applicant_params[:city] if mentee_applicant_params[:city]
    @mentee_applicant.us_living = mentee_applicant_params[:us_living] if mentee_applicant_params[:us_living]
    @mentee_applicant.location = mentee_applicant_params[:state] if mentee_applicant_params[:us_living] == true 
    @mentee_applicant.location = mentee_applicant_params[:country] if mentee_applicant_params[:us_living] == false
    @mentee_applicant.school = mentee_applicant_params[:school] if mentee_applicant_params[:school]
    @mentee_applicant.essay = mentee_applicant_params[:essay] if mentee_applicant_params[:essay]
    
    # backgrounds
    @mentee_applicant.first_gen = mentee_applicant_params[:first_gen] if mentee_applicant_params[:first_gen]
    @mentee_applicant.low_income = mentee_applicant_params[:low_income] if mentee_applicant_params[:low_income]
    @mentee_applicant.stem_girl = mentee_applicant_params[:stem_girl] if mentee_applicant_params[:stem_girl]
    @mentee_applicant.single_parent = mentee_applicant_params[:single_parent] if mentee_applicant_params[:single_parent]
    @mentee_applicant.disabled = mentee_applicant_params[:disabled] if mentee_applicant_params[:disabled]
    @mentee_applicant.lgbt = mentee_applicant_params[:lgbt] if mentee_applicant_params[:lgbt]
    @mentee_applicant.black = mentee_applicant_params[:black] if mentee_applicant_params[:black]
    @mentee_applicant.hispanic = mentee_applicant_params[:hispanic] if mentee_applicant_params[:hispanic]
    @mentee_applicant.asian_pi = mentee_applicant_params[:asian_pi] if mentee_applicant_params[:asian_pi]
    @mentee_applicant.me_na = mentee_applicant_params[:me_na] if mentee_applicant_params[:me_na]
    @mentee_applicant.native = mentee_applicant_params[:native] if mentee_applicant_params[:native]
    @mentee_applicant.immigrant = mentee_applicant_params[:immigrant] if mentee_applicant_params[:immigrant]

    if @mentee_applicant.save
      render(json: @mentee_applicant, status: :created)
    else
      render(json: @mentee_applicant.errors, status: :unprocessable_entity)
    end
  end

  private

  def set_mentee_applicant
    @mentee_applicant = MenteeApplicant.find(params[:mentee_applicant_id])
  end

  def mentee_applicant_params
    params.permit([:mentee_applicant_id, \
      :email, :first_name, :last_name, \
      :state, :country, :us_living, :city, \
      :school, :essay, \
      :first_gen, :low_income, :stem_girl, :single_parent, :disabled, :lgbt, \
      :black, :hispanic, :asian_pi, :me_na, :native, :immigrant ])
  end
end
