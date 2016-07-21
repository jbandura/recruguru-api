RSpec.describe "API::V1::Sessions" do
  describe "GET /api/v1/sessions" do
    let(:user) do
      User.create!(
        email: "foo@admin.local",
        password: "password",
        password_confirmation: "password"
      )
    end
    let(:token) { JSON.parse(response.body)["token"] }
    it "returns auth token for user" do
      post "/api/v1/sessions", user: { email: user.email, password: "password" }
      expect(token).to eq user.authentication_token
    end

    it "returns 401 when login or password wrong" do
      post "/api/v1/sessions", user: { email: "wrong@email.com", password: "wrong-password" }
      expect(response.status).to eq(401)
    end
  end

  describe "DELETE /api/v1/sessions" do
    let(:user) do
      User.create!(
        email: "foo@admin.local",
        password: "password",
        password_confirmation: "password",
        authentication_token: "AUTH_TOKEN"
      )
    end
    it "resets auth token for user" do
      delete "/api/v1/sessions", authentication_token: user.authentication_token
      user = User.where(email: "foo@admin.local").first
      expect(user.authentication_token).not_to eq "AUTH_TOKEN"
    end
  end
end
