class User < ApplicationRecord
  has_many :microposts, dependent: :destroy

  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, uniqueness: {case_sensitive: false}, format: {with: VALID_EMAIL_REGEX}
  has_secure_password
  validates :password, presence:true, length: {minimum: 6}

  before_save :downcase_email
  before_create :create_activation_digest

  attr_accessor :remember_token, :activation_token, :reset_token

  class << self

    def activated_and_paginated_users(current_page)
      where(activated: true).paginate(page: current_page)
    end

    # Returns the hash digest of a given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Generates a new random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Returns a user's micropost feed.
  def feed
    microposts
  end

  # Stores a user in the database for persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Checks whether the database stored digest matches the one generated from a given token.
  # Applied to password, remember and activation digests.
  def authenticated?(attribute, token)
    return false if token.nil?
    digest = send("#{attribute}_digest")
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_token, nil)
  end

  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends account activation email.
  def send_activation_email
    UserMailer.send_activation_email(self).deliver_now
  end

  # Sets the password digest attribute.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Sends the password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  private
    
    def downcase_email
      self.email.downcase!
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
