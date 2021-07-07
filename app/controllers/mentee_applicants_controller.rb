class MenteeApplicantsController < ApplicationController
  before_action :authenticate_user, only: %i[index show update]
  before_action :set_mentee_applicant, only: %i[show update]

  # GET /mentee_applicants
  def index
    return render(json: { message: 'You are not master' }, status: :unauthorized) unless is_master

    @mentee_applicants = MenteeApplicant.all
    render(json: @mentee_applicants, status: :ok)
  end

  # POST /mentee_applicants
  def create
    require 'net/http'
    require 'uri'
    # Send to Slack
    uri = URI("https://hooks.slack.com/services/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")
    header = { "Content-Type" => "application/json" }

    incoming_app_notif = { "text" => \
                          "\n Application: Mentee" + \
                          "\n Name: " + mentee_applicant_params[:first_name] + " " +mentee_applicant_params[:family_name] + \
                          "\n Email: " + mentee_applicant_params[:email]
                        }
    request = Net::HTTP.post(uri, incoming_app_notif.to_json, header)
    

    @mentee_applicant = MenteeApplicant.new(email: mentee_applicant_params[:email])
    @mentee_applicant.applicant_password = mentee_applicant_params[:applicant_password] if mentee_applicant_params[:applicant_password]

    @mentee_applicant.phone = mentee_applicant_params[:phone] if mentee_applicant_params[:phone]
    @mentee_applicant.first_name = mentee_applicant_params[:first_name] if mentee_applicant_params[:first_name]
    @mentee_applicant.family_name = mentee_applicant_params[:family_name] if mentee_applicant_params[:family_name]
    @mentee_applicant.city = mentee_applicant_params[:city] if mentee_applicant_params[:city]
    @mentee_applicant.us_living = mentee_applicant_params[:us_living] if mentee_applicant_params[:us_living]
    @mentee_applicant.location = mentee_applicant_params[:state] if mentee_applicant_params[:us_living] == true 
    @mentee_applicant.location = mentee_applicant_params[:country] if mentee_applicant_params[:us_living] == false
    @mentee_applicant.school = mentee_applicant_params[:school] if mentee_applicant_params[:school]
    @mentee_applicant.essay = mentee_applicant_params[:essay] if mentee_applicant_params[:essay]
    @mentee_applicant.hobby = mentee_applicant_params[:hobby] if mentee_applicant_params[:hobby]
    @mentee_applicant.extra_component = mentee_applicant_params[:extra_component] if mentee_applicant_params[:extra_component]

    # backgrounds
    @mentee_applicant.first_gen = mentee_applicant_params[:first_gen] if mentee_applicant_params[:first_gen]
    @mentee_applicant.low_income = mentee_applicant_params[:low_income] if mentee_applicant_params[:low_income]
    @mentee_applicant.stem_girl = mentee_applicant_params[:stem_girl] if mentee_applicant_params[:stem_girl]
    @mentee_applicant.single_parent = mentee_applicant_params[:single_parent] if mentee_applicant_params[:single_parent]
    @mentee_applicant.disabled = mentee_applicant_params[:disabled] if mentee_applicant_params[:disabled]
    @mentee_applicant.lgbt = mentee_applicant_params[:lgbt] if mentee_applicant_params[:lgbt]
    @mentee_applicant.black = mentee_applicant_params[:black] if mentee_applicant_params[:black]
    @mentee_applicant.hispanic = mentee_applicant_params[:hispanic] if mentee_applicant_params[:hispanic]
    @mentee_applicant.asian = mentee_applicant_params[:asian] if mentee_applicant_params[:asian]
    @mentee_applicant.pi = mentee_applicant_params[:pi] if mentee_applicant_params[:pi]
    @mentee_applicant.me_na = mentee_applicant_params[:me_na] if mentee_applicant_params[:me_na]
    @mentee_applicant.native = mentee_applicant_params[:native] if mentee_applicant_params[:native]
    @mentee_applicant.immigrant = mentee_applicant_params[:immigrant] if mentee_applicant_params[:immigrant]
    @mentee_applicant.undoc = mentee_applicant_params[:undoc] if mentee_applicant_params[:undoc]
    @mentee_applicant.grad_year = mentee_applicant_params[:grad_year] if mentee_applicant_params[:grad_year]
    @mentee_applicant.interests = mentee_applicant_params[:interests] if mentee_applicant_params[:interests]

    if @mentee_applicant.save
      render(json: @mentee_applicant, status: :created)
    else
      render(json: @mentee_applicant.errors, status: :unprocessable_entity)
    end
  end

  # GET /mentee_applicants/:id
  def show
    render(json: { errors: 'Not the correct applicant!' }, status: :unauthorized) if (mentee_applicant_params[:applicant_password] != @mentee_applicant.applicant_password && !is_master)

    render(json: @mentee_applicant.to_json(include: []), status: :ok)
      # :first_gen, :low_income, :stem_girl, :single_parent, :disabled, :lgbt, \
      # :black, :hispanic, :asian, :pi, :me_na, :native, :immigrant, :undoc]), status: :ok)
  end

  # PUT /mentee_applicants/:id
  def update
    return render(json: { message: 'You are not master' }, status: :unauthorized) unless is_master

    @mentee_applicant.applicant_status = mentee_applicant_params[:applicant_status]

    if @mentee_applicant.save
      render(json: @mentee_applicant.to_json(include: []), status: :ok)
    else
      render(json: @mentee_applicant.to_json(include: []), status: :ok)
    end
  end

  # POST /mentee_applicants/accept
  def accept
    MenteeApplicant.all.each {
      |applicant|
      
      # first create the mentee record
      mentee_user = User.find_by(email: applicant.email)

      if mentee_user.blank?
        @mentee = Mentee.new()

        @mentee.user = User.new(account: @mentee, email: applicant.email.strip, phone: applicant.phone, name: applicant.first_name + " " + applicant.family_name, school: applicant.school, grad_year: applicant.grad_year)

        if @mentee.save
        else
          puts @mentee.errors
        end

      else
        #   puts 'User already exists'
        old_account = mentee_user.account
        old_account.destroy

        @mentee = Mentee.new()
        
        mentee_user.update(account: @mentee, email: applicant.email.strip, phone: applicant.phone, given_name: applicant.first_name, family_name: applicant.family_name, name: applicant.first_name + " " + applicant.family_name, school: applicant.school, grad_year: applicant.grad_year)
        
        if mentee_user.save
        else
          puts mentee_user.errors
        end
      end

    }

    render(json: { message: 'All accepted!' })
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
