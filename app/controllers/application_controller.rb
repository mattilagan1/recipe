class ApplicationController < ActionController::API
  def encode_token(payload)
    JWT.encode(payload, Rails.application.secret_key_base)
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    return nil unless auth_header
    token = auth_header.split(' ')[1]

    begin
      JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
    rescue JWT::DecodeError
      nil
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]["user_id"]
      User.find_by(id: user_id)
    end
  end

  def authorized
    render json: { error: "Please log in" }, status: :unauthorized unless current_user
  end
end
