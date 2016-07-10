class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge

  validates_presence_of :user
  validates_presence_of :challenge
end
