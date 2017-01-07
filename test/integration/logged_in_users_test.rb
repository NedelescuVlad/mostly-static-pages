require 'test_helper'

class LoggedInSiteNavigationTest < ActionDispatch::IntegrationTest
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

	test "unsuccessful edit" do
		log_in_as @user
		get edit_user_path(@user)
		assert_template 'users/edit'
		patch user_path(@user), params: { user: { name: "",
	 																						email: "foobar@invalid",
																							password: "",
		                                          password_confirmation: "foobar"} }
		assert_template 'users/edit'
	end

	test "successful edit with friendly redirect" do
		get edit_user_path(@user)
		assert_not session[:forwarding_url].nil?
		log_in_as @user
		assert_redirected_to edit_user_url(@user)
		name = "Michael Hartl"
		email = "michael@hartl.com"
		patch user_path(@user), params: { user: { name: name,
																							email: email,
																							password: "123456",
		                                          password_confirmation: "123456"} }
		assert_not flash.empty?
		assert_redirected_to @user
		@user.reload
		assert_equal name, @user.name
		assert_equal email, @user.email
		assert session[:forwarding_url].nil?
	end
end
