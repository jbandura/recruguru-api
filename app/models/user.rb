class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :categories
  has_many :challenges
  enum role: [:user, :admin]

  after_initialize :set_user_role, if: :new_record?
  before_save :ensure_authentication_token

  def set_user_role
    self.role ||= :user
  end

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def reset_authentication_token
    self.authentication_token = generate_authentication_token
    save
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
