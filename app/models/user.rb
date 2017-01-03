class User < ApplicationRecord
	attr_accessor :remember_token

	before_save { self.email.downcase! }

	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255}, uniqueness: {case_sensitive: false}, format: {with: VALID_EMAIL_REGEX}

	has_secure_password
	validates :password, presence:true, length: {minimum: 6}

	class << self

		# Returns the hash digest of a given string
		def digest(string)
			cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
																										BCrypt::Engine.cost
			BCrypt::Password.create(string, cost: cost)
		end

		# Generates a new random token
		def new_token
			SecureRandom.urlsafe_base64
		end
	end

	# Stores a user in the database for persistent sessions.
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	def authenticated?(remember_token)
		return false if remember_token.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	def forget
		update_attribute(:remember_token, nil)
	end
end
