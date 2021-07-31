class UsersController < ApplicationController
  before_action :authenticate_user, only: %i[show update index master_update]
  before_action :set_user, only: %i[show update events]
  before_action :authorize_user, only: %i[show update index]

  # POST /google_login
  def google_login
    # jwk = {
    #   "keys": [
    #     {
    #       "use": "sig",
    #       "kid": "744f60e9fb515a2a01c11ebeb228712860540711",
    #       "e": "AQAB",
    #       "n": "omK-BgTldoGjO0zHDNXELv4756vbdFPcfTqzs21pQkW9kYlos11jFIomZLa9WgtUVfjF1qjPm8J_UGcmyQNoXOqweY6UusEXhb-sLQ4_5o_R1TlrP2X0bmDwJqMa41ZZR2cs0XGP8B9bWMpq-hTwOHLzMgMc0e4Dty7u8vASve_aH6_11FvNDzFu79ixCId8VwxEPdTeWCZXYRQpTQpw0Kh_koXlV39iVvcH2DmuCmXJKoW2PDXOD4Y7wF_R0mYS6df13jBRNrvlBEDMgx6utKRFYDTWeRrTPBnseWY9Kk48mcAuwOucMs8ce2q9cjyFypnoIkaIdz8dumLk8iqjNQ",
    #       "kty": "RSA",
    #       "alg": "RS256"
    #     },
    #     {
    #       "kid": "6bc63e9f18d561b34f5668f88ae27d48876d8073",
    #       "kty": "RSA",
    #       "e": "AQAB",
    #       "alg": "RS256",
    #       "use": "sig",
    #       "n": "oprIf14gjc4QjI4YUC0COkn4KAjkBeaEYiPm6jo1G9gngKGflmmfsviR8M3rIKs96DzgurM2U1X2TUIDhqBvNHtUONclV6anAR220PcS72l__rCo9tRQxk7pUDQSZxbbi6a0t5w35FyBoF6agPSK3-nEfOk1_vwD1pivo5X7lrvHSu_0lZ-IfaNF-DhErGTeWb2Zu4fOMtadWfRJrTp3UdaWFvHZxkVZLIQGNFeEcKapVpAB2ey8bmzz1rYHx0LA-DWMxhfiBvA81e68S2dD8ukHjDtgzh2lkWJffJ-H7ncF7Sli_RBuWShWl0q0CtIeW5PBkwVCmrktZtINPV7h5Q"
    #     }
    #   ]
    # }

    # jwk_loader = ->(options) do
    #   @cached_keys = nil if options[:invalidate] # need to reload the keys
    #   @cached_keys ||= { keys: [jwk.export] }
    # end
    
    begin
      # decoded_hash = JWT.decode(user_params[:google_token], nil, true, { algorithms: ['RS512'], jwks: jwk_loader})
      decoded_hash = JWT.decode(user_params[:google_token], nil, false)
    # rescue JWT::JWKError
    #   decoded_hash = []
    rescue JWT::DecodeError
      decoded_hash = []
    end

    if decoded_hash && !decoded_hash.empty?
      return render(json: { message: 'Incorrect client' }, status: :unauthorized) if decoded_hash[0]['aud'] != ENV['GOOGLE_OAUTH2_CLIENT_ID']
      return render(json: { message: 'Incorrect issuer' }, status: :unauthorized) if decoded_hash[0]['iss'] != 'accounts.google.com'

      google_id = decoded_hash[0]['sub']
      email = decoded_hash[0]['email']
      name = decoded_hash[0]['name']
      given_name = decoded_hash[0]['given_name']
      family_name = decoded_hash[0]['family_name']
      image_url = decoded_hash[0]['picture']

      @user = User.find_by(email: email)
      
      if @user.blank?
        return render(json: { message: 'You are not a mentor or mentee!' }, status: :ok)
      
      else
        return render(json: { message: 'You are not a mentor or mentee!' }, status: :ok) if @user.status != 'accepted'
        
        @user.update(
          name: name,
          image_url: image_url,
          given_name: given_name,
          family_name: family_name,
          google_id: google_id,
        )
        @user.update(display_name: name) if @user.display_name.blank?
      end

      refresh_token_id = SecureRandom.uuid

      @user.update(
        refresh_token_id: refresh_token_id
      )

      render(json: {
        message: 'Logged in!',
        access_token: encode_access_token({ user_id: @user.id }),
        refresh_token: encode_refresh_token({ user_id: @user.id, id: refresh_token_id }),
        user: @user.as_json(except: [:refresh_token_id, :status]),
        account: @user.account,
        }, status: :ok)
    else
      render(json: { message: 'Incorrect login' }, status: :unauthorized)
    end
  end

  # POST /applicant_google_login
  def applicant_google_login
    # jwk = {
    #   "keys": [
    #     {
    #       "use": "sig",
    #       "kid": "744f60e9fb515a2a01c11ebeb228712860540711",
    #       "e": "AQAB",
    #       "n": "omK-BgTldoGjO0zHDNXELv4756vbdFPcfTqzs21pQkW9kYlos11jFIomZLa9WgtUVfjF1qjPm8J_UGcmyQNoXOqweY6UusEXhb-sLQ4_5o_R1TlrP2X0bmDwJqMa41ZZR2cs0XGP8B9bWMpq-hTwOHLzMgMc0e4Dty7u8vASve_aH6_11FvNDzFu79ixCId8VwxEPdTeWCZXYRQpTQpw0Kh_koXlV39iVvcH2DmuCmXJKoW2PDXOD4Y7wF_R0mYS6df13jBRNrvlBEDMgx6utKRFYDTWeRrTPBnseWY9Kk48mcAuwOucMs8ce2q9cjyFypnoIkaIdz8dumLk8iqjNQ",
    #       "kty": "RSA",
    #       "alg": "RS256"
    #     },
    #     {
    #       "kid": "6bc63e9f18d561b34f5668f88ae27d48876d8073",
    #       "kty": "RSA",
    #       "e": "AQAB",
    #       "alg": "RS256",
    #       "use": "sig",
    #       "n": "oprIf14gjc4QjI4YUC0COkn4KAjkBeaEYiPm6jo1G9gngKGflmmfsviR8M3rIKs96DzgurM2U1X2TUIDhqBvNHtUONclV6anAR220PcS72l__rCo9tRQxk7pUDQSZxbbi6a0t5w35FyBoF6agPSK3-nEfOk1_vwD1pivo5X7lrvHSu_0lZ-IfaNF-DhErGTeWb2Zu4fOMtadWfRJrTp3UdaWFvHZxkVZLIQGNFeEcKapVpAB2ey8bmzz1rYHx0LA-DWMxhfiBvA81e68S2dD8ukHjDtgzh2lkWJffJ-H7ncF7Sli_RBuWShWl0q0CtIeW5PBkwVCmrktZtINPV7h5Q"
    #     }
    #   ]
    # }

    # jwk_loader = ->(options) do
    #   @cached_keys = nil if options[:invalidate] # need to reload the keys
    #   @cached_keys ||= { keys: [jwk.export] }
    # end
    
    begin
      # decoded_hash = JWT.decode(user_params[:google_token], nil, true, { algorithms: ['RS512'], jwks: jwk_loader})
      decoded_hash = JWT.decode(user_params[:google_token], nil, false)
    # rescue JWT::JWKError
    #   decoded_hash = []
    rescue JWT::DecodeError
      decoded_hash = []
    end

    if decoded_hash && !decoded_hash.empty?
      return render(json: { message: 'Incorrect client' }, status: :unauthorized) if decoded_hash[0]['aud'] != ENV['GOOGLE_OAUTH2_CLIENT_ID']
      return render(json: { message: 'Incorrect issuer' }, status: :unauthorized) if decoded_hash[0]['iss'] != 'accounts.google.com'

      google_id = decoded_hash[0]['sub']
      email = decoded_hash[0]['email']
      name = decoded_hash[0]['name']
      given_name = decoded_hash[0]['given_name']
      family_name = decoded_hash[0]['family_name']
      image_url = decoded_hash[0]['picture']

      @user = User.find_by(email: email)
      
      if @user.blank?
        @user = User.new(
          name: name,
          image_url: image_url,
          given_name: given_name,
          family_name: family_name,
          google_id: google_id
        )
      else
        @user.update(
          name: name,
          image_url: image_url,
          given_name: given_name,
          family_name: family_name,
          google_id: google_id,
        )
      end

      @user.update(display_name: name) if @user.display_name.blank?

      refresh_token_id = SecureRandom.uuid

      @user.update(
        refresh_token_id: refresh_token_id
      )

      render(json: {
        message: 'Logged in!',
        applicant_token: encode_applicant_token({ user_id: @user.id }),
        refresh_token: encode_refresh_token({ user_id: @user.id, id: refresh_token_id }),
        user: @user.as_json(except: [:refresh_token_id, :status]),
        }, status: :ok)
    else
      render(json: { message: 'Incorrect login' }, status: :unauthorized)
    end
  end

  # GET /users
  def index
    if is_master
      @users = User.all
      render(json: @users.to_json(include: :account))
    else
      render(json: { message: 'You are not master' }, status: :unauthorized)
    end
  end

  # GET /users/:id
  def show
    render(json: { errors: 'Not the correct user!' }, status: :unauthorized) if (current_user != @user && !is_master)

    if @user.account_type == 'Mentor'
      render(json: { user: @user, account: @user.account.as_json(include: [mentees: { include: :user }]) }, status: :ok)
    elsif @user.account_type == 'Mentee'
      render(json: { user: @user, account: @user.account.as_json(include: [mentor: { include: :user }]) }, status: :ok)
    end
  end

  # PUT /users/:id
  def update
    render(json: { errors: 'Not the correct user!' }, status: :unauthorized) if (current_user != @user)
    
    @user.email = user_params[:email].strip if user_params[:email]
    @user.phone = user_params[:phone] if user_params[:phone]
    @user.bio = user_params[:bio] if user_params[:bio]
    @user.display_name = user_params[:display_name] if user_params[:display_name]
    @user.grad_year = user_params[:grad_year] if user_params[:grad_year]
    @user.school = user_params[:school] if user_params[:school]
    @user.image_url = user_params[:image_url] if user_params[:image_url]

    if @user.save
      render(json: @user, status: :ok)
    else
      render(json: @user.errors, status: :unprocessable_entity)
    end
  end

  # PUT /users/applicant_update
  def applicant_update
    require 'net/http'
    require 'uri'
    #Send to Slack
    uri = URI("https://hooks.slack.com/services/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")
    header = { "Content-Type" => "application/json" }

    incoming_app_notif = { "text" => \
                          "\n Application: " + user_params[:applicant_type] + \
                          "\n Name: " + user_params[:first_name] + " " +user_params[:family_name] + \
                          "\n Email: " + user_params[:email] \
                        }
    request = Net::HTTP.post(uri, incoming_app_notif.to_json, header)

    @user = User.find_by(email: user_params[:email])
    return render(json: { errors: 'Not the correct user!' }, status: :unauthorized) if (current_applicant != @user)
    
    @user.phone = user_params[:phone] if user_params[:phone]
    @user.school = user_params[:school] if user_params[:school]
    @user.grad_year = user_params[:grad_year] if user_params[:grad_year]
    @user.grad_year = 2023 if user_params[:applicant_type] == "Mentee"
    @user.given_name = user_params[:first_name] if user_params[:first_name]
    @user.family_name = user_params[:family_name] if user_params[:family_name]
    @user.city = user_params[:city] if user_params[:city]
    @user.us_living = user_params[:us_living] if user_params[:us_living]
    @user.location = user_params[:state] if user_params[:us_living] == true 
    @user.location = user_params[:country] if user_params[:us_living] == false
    @user.essay = user_params[:essay] if user_params[:essay]
    @user.backgrounds = user_params[:backgrounds] if user_params[:backgrounds]
    @user.interests = user_params[:interests] if user_params[:interests]
    @user.account_type = user_params[:applicant_type]
    @user.multi_mentees = user_params[:multi_mentees] if user_params[:applicant_type] == "Mentor"
    
    @user.status = "applied"

    if @user.save
      return render(json: @user, status: :ok)
    else
      return render(json: @user.errors, status: :unprocessable_entity)
    end
  end

  # PUT /users/master_update
  def master_update
    render(json: { message: 'You are not master' }, status: :unauthorized) unless is_master

    other_user = User.find(user_params[:other_user_id])

    other_user.email = user_params[:email].strip if user_params[:email]
    other_user.phone = user_params[:phone] if user_params[:phone]
    other_user.bio = user_params[:bio] if user_params[:bio]
    other_user.display_name = user_params[:display_name] if user_params[:display_name]
    other_user.grad_year = user_params[:grad_year] if user_params[:grad_year]
    other_user.school = user_params[:school] if user_params[:school]
    other_user.image_url = user_params[:image_url] if user_params[:image_url]

    if other_user.save
      render(json: other_user, status: :ok)
    else
      render(json: other_user.errors, status: :unprocessable_entity)
    end
  end

  # PUT /users/update_status
  def update_status
    render(json: { message: 'You are not master' }, status: :unauthorized) unless is_master

    other_user = User.find(user_params[:other_user_id])

    other_user.status = user_params[:status] if user_params[:status]
  end

  # GET /users/:id/events
  def events
    public_events = Event.where(kind: 'open')
    fellows_only_events = Event.where(kind: 'fellows_only')
    invited_events = @user.invited_events

    @events = public_events + fellows_only_events + invited_events

    @events.each do |event|
      event.current_user = current_user
    end

    render(json: @events.to_json(methods: [:user_registration]), status: :ok)
  end

  private

  def user_params
    params.permit(:image_url, :bio, :display_name, :phone, :school, :grad_year, :email, \
      :other_user_id, :google_token, \
      :applicant_user_id, :applicant_type, :multi_mentees, \
      :city, :state,  :country, :essay, :first_name, :family_name, :us_living, \
      :interests, :backgrounds, \
      :status
    )
  end

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    render(json: { errors: 'Not the correct user!' }, status: :unauthorized) if current_user != @user
  end

end
