module API
  module V1
    class ChallengeVotes < Grape::API
      include API::V1::Defaults

      resource :challenge_votes do
        get { ChallengeVote.all }
      end
    end
  end
end
