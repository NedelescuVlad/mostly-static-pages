require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

	test "login with valid information" do
		User.create(name: 'Sample User', email: 'example@example.org', 
								password: 'foobar', password_confirmation: 'foobar')
		get login_path
		assert_template 'sessions/new'
		post login_path, params: {session: {email: 'example@example.org', password: 'foobar'}}
		follow_redirect!
		assert_template 'users/show'
		assert_not session[:user_id].nil?
	end

	test "login with invalid information" do
		get login_path
		assert_template 'sessions/new'
		post login_path, params: {session: {email: "", password: ""}}
		assert_template 'sessions/new'
		assert_not flash.empty?
		get root_path
		assert flash.empty?
	end
end
