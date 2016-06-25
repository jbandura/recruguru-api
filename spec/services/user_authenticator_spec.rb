RSpec.describe UserAuthenticator do
  let(:user_stub) do
    User.new(
      email: "admin@email.com",
      password: "foobarpassword",
      authentication_token: "AUTHENTICATION_TOKEN"
    )
  end

  context "#authenticate" do
    let(:subject) { UserAuthenticator.new }

    it "returns false when email or password missing" do
      expect(subject.authenticate(nil, nil)).to eq(false)
      expect(subject.authenticate(nil, "foopassword")).to eq(false)
      expect(subject.authenticate("email", nil)).to eq(false)
    end

    it "return false when user not found" do
      expect(User).to receive(:where)
        .with(email: user_stub.email)
        .and_return([])
      jwt = subject.authenticate("admin@email.com", "foobarpassword")
      expect(jwt).to eq(false)
    end

    it "return false when credentials do not match" do
      expect(User).to receive(:where)
        .with(email: "notmatch@email.com")
        .and_return([user_stub])
      jwt = subject.authenticate("notmatch@email.com", "badpassword")
      expect(jwt).to eq(false)
    end

    it "returns JWT when proper credentials passed" do
      expect(User).to receive(:where)
        .with(email: user_stub.email)
        .and_return([user_stub])
      jwt = subject.authenticate("admin@email.com", "foobarpassword")
      expect(jwt[:token]).to eq(user_stub.authentication_token)
    end
  end

  context "#destroy_token" do
    it "destroys token of an existing user" do
      expect(User).to receive(:where)
        .with(authentication_token: "AUTHENTICATION_TOKEN")
        .and_return([user_stub])
      allow(user_stub).to receive(:generate_authentication_token).and_return "NEW_AUTH_TOKEN"
      UserAuthenticator.new.destroy_token("AUTHENTICATION_TOKEN")
      expect(user_stub.authentication_token).to eq("NEW_AUTH_TOKEN")
    end

    it "returns false when user doesn't exist" do
      expect(User).to receive(:where)
        .with(authentication_token: "AUTHENTICATION_TOKEN")
        .and_return([])
      result = UserAuthenticator.new.destroy_token("AUTHENTICATION_TOKEN")
      expect(result).to eq(false)
    end
  end
end
