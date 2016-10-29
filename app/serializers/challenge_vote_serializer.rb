class ChallengeVoteSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :challenge_id
end
