module API
  module V1
    class ChallengeVotes < Grape::API
      include API::V1::Defaults

      resource :challenge_votes do
        desc "Get all votes"
        get { ChallengeVote.all }

        desc "Create a vote"
        params do
          requires :challenge_vote, type: Hash do
            requires :challenge_id, type: Integer
            requires :user_id, type: Integer
          end
        end
        post do
          uid = permitted_params[:challenge_vote][:user_id]
          cid = permitted_params[:challenge_vote][:challenge_id]
          if ChallengeVote.where(challenge_id: cid, user_id: uid).present?
            return error!("This user has already voted for this challenge", 403)
          else
            ChallengeVote.create!(user_id: uid, challenge_id: cid)
          end
        end

        route_param :id do
          desc "Undo a vote"
          delete do
            vote = ChallengeVote.find(params[:id])
            vote.destroy!
            status 204
          end
        end
      end
    end
  end
end
