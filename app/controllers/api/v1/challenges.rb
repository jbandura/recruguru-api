module API
  module V1
    class Challenges < Grape::API
      include API::V1::Defaults

      resource :challenges do
        desc "Get all challenges"
        get { return Challenge.all }

        desc "Create a new challenge"
        params do
          requires :challenge, type: Hash do
            requires :title, type: String
            requires :content, type: String
            requires :solution, type: String
            requires :user_id, type: Integer
            requires :category_id, type: Integer
          end
        end

        post do
          challenge_params = permitted_params[:challenge]
          Challenge.create!(
            title: challenge_params[:title],
            content: challenge_params[:content],
            solution: challenge_params[:solution],
            user_id: challenge_params[:user_id],
            category_id: challenge_params[:category_id]
          )
        end

        route_param :id do
          desc "Get specific challenge by ID"
          get do
            Challenge.find(params[:id])
          end

          desc "Update specific challenge"
          params do
            requires :challenge, type: Hash do
              requires :title, type: String
              requires :content, type: String
              requires :solution, type: String
              requires :user_id, type: Integer
              requires :category_id, type: Integer
            end
          end

          put do
            challenge_params = permitted_params[:challenge]
            challenge = Challenge.find(params[:id])
            authorize challenge, :update?
            challenge.update!(
              title: challenge_params[:title],
              content: challenge_params[:content],
              solution: challenge_params[:solution],
              user_id: challenge_params[:user_id],
              category_id: challenge_params[:category_id]
            )
          end

          desc "Delete a challenge"
          delete do
            challenge = Challenge.find(params[:id])
            authorize challenge, :destroy?
            challenge.destroy
            nil
          end
        end
      end
    end
  end
end
