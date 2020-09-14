class TokensController < ApplicationController

  # POST /tokens/refresh
  def refresh
    begin
      decoded_refresh_token = JWT.decode(token_params[:refresh_token], ENV['SECRET_KEY_BASE'])
    rescue JWT::DecodeError
      []
    end

    if decoded_refresh_token && !decoded_refresh_token.empty?
      user_id = decoded_refresh_token[0]['user_id']
      @user = User.find(user_id)

      if @user.refresh_token_id == decoded_refresh_token[0]['id']
        render(json: {
          message: 'Token exchange successful',
          access_token: encode_access_token({ user_id: @user.id }),
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
