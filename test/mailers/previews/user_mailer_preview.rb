class UserMailerPreview < ActionMailer::Preview
  attr_reader :user

  def account_activation
    @user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end
end
