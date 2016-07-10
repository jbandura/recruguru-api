class Challenge < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :challenge_votes

  validates_presence_of :title, :content
end
