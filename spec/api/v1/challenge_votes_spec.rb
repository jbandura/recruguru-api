RSpec.describe "API::V1::ChallengeVotes" do
  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive(:authenticated?).and_return(true)
      allow(endpoint).to receive(:current_user).and_return(user)
    end
  end
  let(:resp) { JSON.parse(response.body)["challenge_votes"] }
  let(:user) { create(:user) }
  let(:challenge) { create(:challenge) }
  let(:api_url) { "/api/v1/challenge_votes" }

  describe "GET /api/v1/challenge_votes" do
    it "should return a list of votes" do
      create_list(:challenge_vote, 3, user: user, challenge: challenge)
      get api_url
      expect(resp.length).to eq 3
    end
  end
end
