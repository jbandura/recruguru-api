class ChallengeSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :solution
  has_one :category, embed: :ids, embed_in_root: true
end
