class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  # include Knock::Authenticable

  private

  def encode_access_token(payload={})
    payload[:typ] = "access"
    payload[:exp] = 6.hours.from_now.to_i # Long access token until refresh token works
    payload[:iat] = Time.now.to_i
    JWT.encode(payload, ENV['SECRET_KEY_BASE'])
  end

  def encode_refresh_token(payload={})
    payload[:typ] = "refresh"
    payload[:exp] = 24.hours.from_now.to_i
    payload[:iat] = Time.now.to_i
    JWT.encode(payload, ENV['SECRET_KEY_BASE'])
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, ENV['SECRET_KEY_BASE'])
      rescue JWT::DecodeError
        []
      end
    end
  end

  def current_account
    decoded_hash = decoded_token
    Rails.logger.info "Decoded Token"
    Rails.logger.info decoded_hash
    if decoded_hash && !decoded_hash.empty?
      account_id = decoded_hash[0]['account_id']
      @account = Account.find(account_id)
    end
  end

  def logged_in?
    !!current_account
  end

  def authenticate_account
    render(json: { message: 'Please login or refresh token' }, status: :ok) unless logged_in?
  end

  def is_mentor
    (current_account.user_type == 'Mentor')
  end

  def is_master
    (current_account.email == 'paulazhu@college.harvard.edu' || \
      current_account.email == 'reachpaulazhu@gmail.com' || \
      current_account.email == 'team.collegearch@gmail.com' || \
      current_account.email == 'tech.collegearch@gmail.com' || \
      current_account.email == 'programming.collegearch@gmail.com' || \
      current_account.email == 'snalani731@gmail.com' || \
      current_account.email == 'llin1@college.harvard.edu' || \
      current_account.email == 'lindalin2812@gmail.com'
    )
  end
end
