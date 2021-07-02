class MentorApplicantsController < ApplicationController
  before_action :authenticate_user, only: %i[index show update]
  before_action :set_mentor_applicant, only: %i[show update]

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
    require 'net/http'
    require 'uri'
    # Send to Slack
    uri = URI("https://hooks.slack.com/services/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")
    header = { "Content-Type" => "application/json" }

    incoming_app_notif = { "text" => \
                          "\n Application: Mentor" + \
                          "\n Name: " + mentor_applicant_params[:first_name] + " " +mentor_applicant_params[:family_name] + \
                          "\n Email: " + mentor_applicant_params[:email]
                        }
    request = Net::HTTP.post(uri, incoming_app_notif.to_json, header)


    @mentor_applicant = MentorApplicant.new(email: mentor_applicant_params[:email])
    @mentor_applicant.applicant_password = mentor_applicant_params[:applicant_password] if mentor_applicant_params[:applicant_password]

    @mentor_applicant.phone = mentor_applicant_params[:phone] if mentor_applicant_params[:phone]
    @mentor_applicant.first_name = mentor_applicant_params[:first_name] if mentor_applicant_params[:first_name]
    @mentor_applicant.family_name = mentor_applicant_params[:family_name] if mentor_applicant_params[:family_name]
    @mentor_applicant.city = mentor_applicant_params[:city] if mentor_applicant_params[:city]
    @mentor_applicant.us_living = mentor_applicant_params[:us_living] if mentor_applicant_params[:us_living]
    @mentor_applicant.location = mentor_applicant_params[:state] if mentor_applicant_params[:us_living] == true 
    @mentor_applicant.location = mentor_applicant_params[:country] if mentor_applicant_params[:us_living] == false
    @mentor_applicant.school = mentor_applicant_params[:school] if mentor_applicant_params[:school]
    @mentor_applicant.essay = mentor_applicant_params[:essay] if mentor_applicant_params[:essay]
    @mentor_applicant.hobby = mentor_applicant_params[:hobby] if mentor_applicant_params[:hobby]
    @mentor_applicant.extra_component = mentor_applicant_params[:extra_component] if mentor_applicant_params[:extra_component]
    @mentor_applicant.interests = mentor_applicant_params[:interests] if mentor_applicant_params[:interests]

    # backgrounds
    @mentor_applicant.first_gen = mentor_applicant_params[:first_gen] if mentor_applicant_params[:first_gen]
    @mentor_applicant.low_income = mentor_applicant_params[:low_income] if mentor_applicant_params[:low_income]
    @mentor_applicant.stem_girl = mentor_applicant_params[:stem_girl] if mentor_applicant_params[:stem_girl]
    @mentor_applicant.single_parent = mentor_applicant_params[:single_parent] if mentor_applicant_params[:single_parent]
    @mentor_applicant.disabled = mentor_applicant_params[:disabled] if mentor_applicant_params[:disabled]
    @mentor_applicant.lgbt = mentor_applicant_params[:lgbt] if mentor_applicant_params[:lgbt]
    @mentor_applicant.black = mentor_applicant_params[:black] if mentor_applicant_params[:black]
    @mentor_applicant.hispanic = mentor_applicant_params[:hispanic] if mentor_applicant_params[:hispanic]
    @mentor_applicant.asian = mentor_applicant_params[:asian] if mentor_applicant_params[:asian]
    @mentor_applicant.pi = mentor_applicant_params[:pi] if mentor_applicant_params[:pi]
    @mentor_applicant.me_na = mentor_applicant_params[:me_na] if mentor_applicant_params[:me_na]
    @mentor_applicant.native = mentor_applicant_params[:native] if mentor_applicant_params[:native]
    @mentor_applicant.immigrant = mentor_applicant_params[:immigrant] if mentor_applicant_params[:immigrant]
    @mentor_applicant.undoc = mentor_applicant_params[:undoc] if mentor_applicant_params[:undoc]
    @mentor_applicant.grad_year = mentor_applicant_params[:grad_year] if mentor_applicant_params[:grad_year]
    @mentor_applicant.multi_mentees = mentor_applicant_params[:multi_mentees] if mentor_applicant_params[:multi_mentees]

    if @mentor_applicant.save
      render(json: @mentor_applicant, status: :created)
    else
      render(json: @mentor_applicant.errors, status: :unprocessable_entity)
    end
  end

  # GET /mentor_applicants/:id
  def show
    render(json: { errors: 'Not the correct applicant!' }, status: :unauthorized) if (mentor_applicant_params[:applicant_password] != @mentor_applicant.applicant_password && !is_master)

    render(json: @mentor_applicant.to_json(include: []), status: :ok)
  end

  # PUT /mentor_applicants/:id
  def update
    return render(json: { message: 'You are not master' }, status: :unauthorized) unless is_master

    @mentor_applicant.applicant_status = mentor_applicant_params[:applicant_status]
    
    if @mentor_applicant.save
      render(json: @mentor_applicant.to_json(include: []), status: :ok)
    else
      render(json: @mentor_applicant.errors, status: :unprocessable_entity)
    end
  end

  private

  def set_mentor_applicant
    @mentor_applicant = MentorApplicant.find(params[:id])
  end

  def mentor_applicant_params
    params.permit([:mentor_applicant_id, \
      :email, :phone, :first_name, :family_name, :grad_year, \
      :state, :country, :us_living, :city, \
      :school, :essay, \
      :first_gen, :low_income, :stem_girl, :single_parent, :disabled, :lgbt, \
      :black, :hispanic, :asian, :pi, :me_na, :native, :immigrant, :undoc, \
      :hobby, :extra_component, \
      :interests, \
      :multi_mentees, \
      :password, :applicant_status ])
  end
end
