RSpec.describe Challenge do
  it { is_expected.to have_attribute :title }
  it { is_expected.to have_attribute :content }
  it { is_expected.to have_attribute :solution }

  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :category }
  it { is_expected.to have_many :challenge_votes }

  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
end
