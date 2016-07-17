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

  describe "POST /api/v1/challenge_votes" do
    let(:params) do
      {
        challenge_vote: {
          challenge_id: challenge.id,
          user_id: user.id
        }
      }
    end

    it "should record vote for a specific user" do
      post api_url, params
      expect(response.status).to eq(201)
      last_vote = ChallengeVote.last
      expect(last_vote.user.id).to eq(user.id)
    end

    it "shouldn't allow voting more than once" do
      ChallengeVote.create(user_id: user.id, challenge_id: challenge.id)
      post api_url, params
      expect(response.status).to eq(403)
    end
  end

  describe "DELETE /api/v1/challenge_votes/:id" do
    let(:vote) { create(:challenge_vote, user_id: user.id, challenge_id: challenge.id) }
    it "should undo vote" do
      delete "#{api_url}/#{vote.id}"
      expect(response.status).to eq(204)
      expect(ChallengeVote.count).to eq(0)
    end
  end
end
