class ChallengeSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :solution
end
