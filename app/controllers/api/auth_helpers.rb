module API
  module AuthHelpers
    def current_user
      return nil if token.nil?
      User.find_by(authentication_token: token)
    end

    def authenticated?
      !!current_user
    end

    def token
      if request.headers["Authorization"].present?
        request.headers["Authorization"].split(' ').last
      end
    end

    def unauthorized_error
      error!("401 Unauthorized", 401)
    end
  end
end
