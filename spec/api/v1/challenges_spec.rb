RSpec.describe "API::V1::Challenges" do
  let(:resp) { JSON.parse(response.body) }
  let(:user) { create(:user) }
  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive(:authenticated?).and_return(true)
      allow(endpoint).to receive(:current_user).and_return(user)
    end
  end

  describe "GET /api/v1/challenges" do
    it "should fetch a list of challenges" do
      challenges = create_list(:challenge, 3, user: user)
      get "/api/v1/challenges"
      expect(response.status).to eq(200)
      expect(resp["challenges"].length).to eq(challenges.length)
    end
  end

  describe "POST /api/v1/challenges" do
    let(:category) { create(:category, user: user) }
    let(:params) do
      {
        challenge: {
          title: "New title",
          content: "New content\nasdasdad",
          solution: "Solution",
          user_id: user.id,
          category_id: category.id,
        }
      }
    end

    it "should add a new challenge" do
      old_challenge_count = Challenge.count
      post "/api/v1/challenges", params
      new_challenge_count = Challenge.count
      expect(response.status).to eq(201)
      expect(new_challenge_count).to eq(old_challenge_count + 1)
      challenge = resp["challenge"]
      expect(challenge["title"]).to eq(params[:challenge][:title])
      expect(challenge["content"]).to eq(params[:challenge][:content])
      expect(challenge["solution"]).to eq(params[:challenge][:solution])
    end
  end

  describe "GET /api/v1/challenge/:id" do
    let(:category) { create(:category, user: user) }
    let(:challenge) { create(:challenge, category: category, user: user) }

    it "should fetch challenge by id" do
      get "/api/v1/challenges/#{challenge.id}"
      expect(response.status).to eq(200)
      expect(resp["challenge"]["title"]).to eq(challenge.title)
      expect(resp["challenge"]["content"]).to eq(challenge.content)
      expect(resp["challenge"]["solution"]).to eq(challenge.solution)
    end
  end
end
