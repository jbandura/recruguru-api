RSpec.describe "API::V1::Challenges" do
  let(:resp) { JSON.parse(response.body) }
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user) }
  let(:challenge) { create(:challenge, category: category, user: user) }
  let(:new_user) { create(:user) }
  let(:other_challenge) { create(:challenge, category: category, user: new_user) }
  let(:api_url) { "/api/v1/challenges" }
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
  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive(:authenticated?).and_return(true)
      allow(endpoint).to receive(:current_user).and_return(user)
    end
  end

  describe "GET /api/v1/challenges" do
    it "should fetch a list of challenges" do
      challenges = create_list(:challenge, 3, user: user)
      get api_url
      expect(response.status).to eq(200)
      expect(resp["challenges"].length).to eq(challenges.length)
    end
  end

  describe "POST /api/v1/challenges" do
    it "should add a new challenge" do
      old_challenge_count = Challenge.count
      post api_url, params
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
    it "should fetch challenge by id" do
      get "#{api_url}/#{challenge.id}"
      expect(response.status).to eq(200)
      expect(resp["challenge"]["title"]).to eq(challenge.title)
      expect(resp["challenge"]["content"]).to eq(challenge.content)
      expect(resp["challenge"]["solution"]).to eq(challenge.solution)
    end
  end

  describe "PUT /api/v1/challenge/:id" do
    it "should allow changing of own challenge" do
      put "#{api_url}/#{challenge.id}", params
      changed_challenge = Challenge.find(challenge.id)
      challenge_params = params[:challenge]
      expect(changed_challenge.title).to eq(challenge_params[:title])
    end

    it "should not allow changing of others challenges" do
      put "#{api_url}/#{other_challenge.id}", params
      expect(response.status).to eq(401)
    end
  end

  describe "DELETE /api/v1/challenges/:id" do
    it "should delete a resource" do
      delete "#{api_url}/#{challenge.id}"
      expect(response.status).to eq(200)
    end

    it "should not allow deleting of not owned resource" do
      delete "#{api_url}/#{other_challenge.id}"
      expect(response.status).to eq(401)
    end
  end
end
