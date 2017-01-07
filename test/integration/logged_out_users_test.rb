require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
		@user = users(:michael)
  end

  test "should get root" do
    get root_url
    assert_response :success
    assert_select "title", "#{@base_title}"
  end

  test "should get home" do
    get home_url
    assert_response :success
    assert_select "title", "#{@base_title}"
  end

  test "should get help" do
    get help_url
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    get about_url
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  test "should get contact" do
    get contact_url
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end

	test "should get show page" do
		get user_path(@user)
		assert_response :success
		assert_template 'users/show'
		assert_select "title", "#{@user.name} | #{@base_title}"
	end

	test "should redirect the edit user action" do
		get edit_user_path @user
		assert_redirected_to login_url
		assert_not flash.empty?
	end

	test "should redirect the update user action" do
		patch user_path(@user), params: {user: {name: "Updated Name", 
																									email: "updated@email.com"}}
		assert_redirected_to login_url
		assert_not flash.empty?
	end
end
