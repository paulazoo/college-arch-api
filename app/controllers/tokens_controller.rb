class TokensController < ApplicationController

  # POST /tokens/refresh
  def refresh
    begin
      decoded_refresh_token = JWT.decode(token_params[:refresh_token], ENV['SECRET_KEY_BASE'])
    rescue JWT::DecodeError
      []
    end

    if decoded_refresh_token && !decoded_refresh_token.empty?
      account_id = decoded_refresh_token[0]['account_id']
      @account = Account.find(account_id)

      if @account.refresh_token_id == decoded_refresh_token[0]['id']
        render(json: {
          message: 'Token exchange successful',
          access_token: encode_access_token({ account_id: @account.id }),
        }, status: :created)
      else
        render(json: { message: 'Please login' }, status: :unauthorized)
      end
    else
      render(json: { message: 'Refresh token not valid' }, status: :unauthorized)
    end
  end

  private

  def token_params
    params.permit(:refresh_token)
  end
end
