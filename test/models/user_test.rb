require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@user = User.new name: "Vlad Nedelescu", email: "vlad@example.com", password: "itsasecret", password_confirmation: "itsasecret"
	end
	
	test "authenticated? should return false for a user with a nil digest" do
		assert_not @user.authenticated?(:remember, nil)
	end

	test "a user with present name and email address is valid" do 
		assert @user.valid?
	end

	test "a user with a present email and valid email format is valid" do
		assert @user.valid?
	end

	test "a blank password is not accepted" do
		@user.password = @user.password_confirmation = " " * 6
		assert_not @user.valid?
	end

	test "a user with non-empty password is valid" do
		assert @user.valid?
	end

	test "an user's password is at least 6 characters" do
		@user.password = @user.password_confirmation = "a" * 5
		assert_not @user.valid?
	end

	test "name is at most 50 characters long" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end

	test "email is at most 255 characters long" do
		@user.email = "a" * 244 + "@example.com"
		assert_not @user.valid?
	end

	test "a user with a blank name is invalid" do
		@user.name = ""
		assert_not @user.valid?
	end

	test "a user with a blank email is invalid" do
		@user.email = ""
		assert_not @user.valid?
	end

	test "email addresses should be unique" do 
		duplicate_user = @user.dup
		duplicate_user.email.upcase!
		@user.save
		assert_not duplicate_user.valid?
	end

	test "email addresses are downcased before database insertion" do
		@user.email = "Kappa@kaPpa.com"
		@user.save
		@user = @user.reload
		assert_equal @user.email, "kappa@kappa.com"
	end

	test "email validation should accept valid email" do
		valid_emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org 
				          first.last@foo.jp alice+bob@baz.cn]

		valid_emails.each do |valid_email|
			@user.email = valid_email 
			assert @user.valid?, "#{@valid_email.inspect} should be valid"
		end
	end

	test "email validation should reject invalid email" do
		invalid_emails = %w[kappa@kappa..123 forsen123 vlad@example sebastian.fors@skillstone @ .@.com @kcl.ac.uk]

		invalid_emails.each do |invalid_email|
			@user.email = invalid_email 
			assert_not @user.valid?, "#{@invalid_email.inspect} should be invalid"
		end
	end
end
