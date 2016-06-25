RSpec.describe User do
  [
    :email, :encrypted_password, :reset_password_token,
    :reset_password_sent_at, :remember_created_at
  ].each do |attribute|
    it { is_expected.to have_attribute attribute }
  end

  it { is_expected.to have_many :categories }
  it { is_expected.to have_many :challenges }
end
