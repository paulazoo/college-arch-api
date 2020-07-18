class AccountsController < ApplicationController
  before_action :authenticate_account, only: %i[show update index]
  before_action :set_account, only: %i[show update]
  before_action :authorize_account, only: %i[show update index]

  # GET /login
  def login
    decoded_hash = decoded_token
    logger.debug(decoded_hash)
    if decoded_hash && !decoded_hash.empty?
      account_id = decoded_hash[0]['sub']
      email = decoded_hash[0]['email']
      name = decoded_hash[0]['name']
      given_name = decoded_hash[0]['given_name']
      family_name = decoded_hash[0]['family_name']
      image_url = decoded_hash[0]['picture']

      @account = Account.find_by(email: email)

      if !@account.blank?
        @account.update(
          name: name,
          image_url: image_url,
          given_name: given_name,
          family_name: family_name,
          google_id: account_id,
        )

        if @account.save
          Analytics.identify(
            userId: @account.id,
            traits: {
              account_id: @account.id,
              email: @account.email.to_s,
              name: @user.name.to_s,
              google_id: @user.google_id.to_s,
            },
            context: { ip: request.remote_ip }
          )

          if @account.user_type == 'Mentor'
            render(json: { message: 'Logged in successfully!', account: @account, user: @account.user.as_json(include: [mentees: { include: :account }]) }, status: :ok)
          elsif @account.user_type == 'Mentee'
            render(json: { message: 'Logged in successfully!', account: @account, user: @account.user.as_json(include: [mentor: { include: :account }]) }, status: :ok)
          end

        else
          render(json: { errors: @account.errors })
        end

      else
        render(json: { message: 'You are not a mentor or mentee!' }, status: :ok)
      end

    else
      render(json: {}, status: :unauthorized)
    end
  end

  # GET /accounts
  def index
    @accounts = Account.all
    json_response(@accounts.to_json(include: :user))
  end

  # GET /accounts/:account_id
  def show
    render(json: { errors: 'Not the correct account!' }, status: :unauthorized) if current_account != @account

    if @account.user_type == 'Mentor'
      render(json: { account: @account, user: @account.user.as_json(include: [mentees: { include: :account }]) }, status: :ok)
    elsif @account.user_type == 'Mentee'
      render(json: { account: @account, user: @account.user.as_json(include: [mentor: { include: :account }]) }, status: :ok)
    end
  end

  # PUT /accounts/:account_id
  def update
    render(json: { errors: 'Not the correct account!' }, status: :unauthorized) if current_account != @account

    @account.update(account_params)

    if @account.save
      render(json: @account, status: :ok)
    else
      render(json: @account.errors, status: :unprocessable_entity)
    end
  end

  private

  def account_params
    params.permit(:image_url, :bio, :display_name, :phone, :school, :grad_year)
  end

  def set_account
    @account = Account.find(params[:account_id])
  end

  def authorize_account
    render(json: { errors: 'Not the correct account!' }, status: :unauthorized) if current_account != @account
  end

end
