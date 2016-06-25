class Category < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :icon
end
