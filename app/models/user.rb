class User < ApplicationRecord
	before_save { email.downcase! }
	
	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255}, uniqueness: {case_sensitive: false}, format: {with: VALID_EMAIL_REGEX}
	has_secure_password

	validates :password, presence:true, length: {minimum: 6}

	# Used only in testing the login
	def User.digest(raw_password)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
																									BCrypt::Engine.cost
		BCrypt::Password.create(raw_password, cost: cost)
	end

end
