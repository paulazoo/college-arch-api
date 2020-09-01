class AccountsController < ApplicationController
  before_action :authenticate_account, only: %i[show update index master_update]
  before_action :set_account, only: %i[show update events]
  before_action :authorize_account, only: %i[show update index]

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
      # decoded_hash = JWT.decode(account_params[:google_token], nil, true, { algorithms: ['RS512'], jwks: jwk_loader})
      decoded_hash = JWT.decode(account_params[:google_token], nil, false)
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

      @account = Account.find_by(email: email)
      
      if @account.blank?
        return render(json: { message: 'You are not a mentor or mentee!' }, status: :ok)
      
      else
        @account.update(
          name: name,
          image_url: image_url,
          given_name: given_name,
          family_name: family_name,
          google_id: google_id,
        )
        @account.update(display_name: name) if @account.display_name.blank?
      end

      refresh_token_id = SecureRandom.uuid

      @account.update(
        refresh_token_id: refresh_token_id
      )
      
      Analytics.identify(
        user_id: @account.id,
        traits: {
          user_id: @account.id,
          email: @account.email.to_s,
          name: @account.name.to_s,
          google_id: @account.google_id.to_s,
        },
        context: { ip: request.remote_ip }
      )

      render(json: {
        message: 'Logged in!',
        access_token: encode_access_token({ account_id: @account.id }),
        refresh_token: encode_refresh_token({ account_id: @account.id, id: refresh_token_id }),
        account: @account.as_json(except: [:refresh_token_id]),
        user: @account.user,
        }, status: :ok)
    else
      render(json: { message: 'Incorrect login' }, status: :unauthorized)
    end
  end

  # GET /accounts
  def index
    if is_master
      @accounts = Account.all
      render(json: @accounts.to_json(include: :user))
    else
      render(json: { message: 'You are not master' }, status: :unauthorized)
    end
  end

  # GET /accounts/:id
  def show
    render(json: { errors: 'Not the correct account!' }, status: :unauthorized) if (current_account != @account && !is_master)

    if @account.user_type == 'Mentor'
      render(json: { account: @account, user: @account.user.as_json(include: [mentees: { include: :account }]) }, status: :ok)
    elsif @account.user_type == 'Mentee'
      render(json: { account: @account, user: @account.user.as_json(include: [mentor: { include: :account }]) }, status: :ok)
    end
  end

  # PUT /accounts/:id
  def update
    render(json: { errors: 'Not the correct account!' }, status: :unauthorized) if (current_account != @account)
 
    @account.email = account_params[:email] if account_params[:email]
    @account.phone = account_params[:phone] if account_params[:phone]
    @account.bio = account_params[:bio] if account_params[:bio]
    @account.display_name = account_params[:display_name] if account_params[:display_name]
    @account.grad_year = account_params[:grad_year] if account_params[:grad_year]
    @account.school = account_params[:school] if account_params[:school]
    @account.image_url = account_params[:image_url] if account_params[:image_url]

    if @account.save
      render(json: @account, status: :ok)
    else
      render(json: @account.errors, status: :unprocessable_entity)
    end
  end

  # PUT /accounts/master_update
  def master_update
    render(json: { message: 'You are not master' }, status: :unauthorized) unless is_master

    other_account = Account.find(account_params[:other_account_id])

    other_account.email = account_params[:email] if account_params[:email]
    other_account.phone = account_params[:phone] if account_params[:phone]
    other_account.bio = account_params[:bio] if account_params[:bio]
    other_account.display_name = account_params[:display_name] if account_params[:display_name]
    other_account.grad_year = account_params[:grad_year] if account_params[:grad_year]
    other_account.school = account_params[:school] if account_params[:school]
    other_account.image_url = account_params[:image_url] if account_params[:image_url]

    if other_account.save
      render(json: other_account, status: :ok)
    else
      render(json: other_account.errors, status: :unprocessable_entity)
    end
  end

  # GET /accounts/:id/events
  def events
    public_events = Event.where(kind: 'open')
    fellows_only_events = Event.where(kind: 'fellows_only')
    invited_events = @account.invited_events

    @events = public_events + fellows_only_events + invited_events

    @events.each do |event|
      event.current_account = current_account
    end

    render(json: @events.to_json(methods: [:account_registration]), status: :ok)
  end

  private

  def account_params
    params.permit(:image_url, :bio, :display_name, :phone, :school, :grad_year, :email, \
      :other_account_id, :google_token)
  end

  def set_account
    @account = Account.find(params[:id])
  end

  def authorize_account
    render(json: { errors: 'Not the correct account!' }, status: :unauthorized) if current_account != @account
  end

end
