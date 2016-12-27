require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

	test "invalid signup request" do
		get signup_path 
		assert_no_difference 'User.count' do
			post users_path, params: {user: {name: 									"", 
																			 email: 								"invalid@invalid", 
																			 password: 							"foo", 
																			 password_confirmation: "foobar"}}
		end
		assert_template 'users/new'
		assert_select 'div#error_explanation'
		assert_select 'div.field_with_errors'
	end

	test "valid signup request" do
		get signup_path 
		assert_difference 'User.count', 1 do
			post users_path, params: {user: {name: 									"Sample User", 
																			 email: 								"valid@example.com", 
																			 password: 							"foobar", 
																			 password_confirmation: "foobar"}}
		end
		follow_redirect!
		assert_template 'users/show'
		assert_not flash.nil?
	end
end
