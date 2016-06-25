class UserAuthenticator
  def authenticate(email, password)
    return false if email.nil? || password.nil?
    user = User.where(email: email.downcase).first
    return false if user.nil? || !user.valid_password?(password)
    {
      token: user.authentication_token.to_s,
      user: user
    }
  end

  def destroy_token(token)
    user = User.where(authentication_token: token).first
    return false if user.nil?
    user.reset_authentication_token
  end
end
