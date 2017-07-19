class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password

  validates :email, format: {with: VALID_EMAIL_REGEX},
   length: {maximum: Settings.email_length_max},
   presence: true, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
   length: {minimum: Settings.password_length_min}
  validates :name, presence: true, length: {maximum: Settings.name_length_max}

  before_save :downcase_email

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
  end

  private

  def downcase_email
    email.downcase!
  end
end
