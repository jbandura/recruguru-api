RSpec.describe ChallengeVote do
  it { is_expected.to belong_to :challenge }
  it { is_expected.to belong_to :user }

  it { should validate_presence_of :user }
  it { should validate_presence_of :challenge }
end
