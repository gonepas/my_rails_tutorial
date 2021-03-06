class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_reader :remember_token
  attr_reader :remember_token, :activation_token

  has_secure_password

  validates :email, format: {with: VALID_EMAIL_REGEX},
   length: {maximum: Settings.email_length_max},
   presence: true, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
   length: {minimum: Settings.password_length_min}, allow_nil: true
  validates :name, presence: true, length: {maximum: Settings.name_length_max}

  before_save :downcase_email
  before_create :create_activation_digest

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    @remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.blank?
    BCrypt::Password.new(digest).is_password? token
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def forget
    update_attributes remember_digest: nil
  end

  def current_user? user
    self == user
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_activation_digest
    @activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end

  private

  def downcase_email
    email.downcase!
  end
end
