module API
  module V1
    class Sessions < Grape::API
      include API::V1::Defaults

      resource :sessions do
        desc "Authenticate user and return user object / access token"

        params do
          requires :user, type: Hash do
            requires :email, type: String, desc: "User email"
            requires :password, type: String, desc: "User password"
          end
        end

        post nil, serializer: nil do
          email = params[:user][:email]
          data = UserAuthenticator.new.authenticate(email, params[:user][:password])
          unless data
            return error!(
              { errors: "Invalid Email or Password." },
              401
            )
          end
          user = UserSerializer.new(data[:user]).to_json
          return {
            token: data[:token],
            email: email,
            user: user,
            user_id: data[:user].id
          }
        end

        params do
          requires :authentication_token, type: String, desc: "Users auth token"
        end

        delete do
          UserAuthenticator.new.destroy_token(params[:authentication_token])
        end
      end
    end
  end
end
