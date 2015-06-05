require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  
  def setup
    @user = users(:michael)
  end
  
  #First version
#  test "login with invalid information" do
#    get login_path
#    assert_template 'sessions/new'	#verify that the new sessions form render properly
#    post login_path, session: { email: "", password: "" } #post to the session path with and invalid params hash
#    assert_template 'sessions/new' #verify that the new sessions form gets re-rendered and a flash message appears
#    assert_not flash.empty?
#    get root_path	#visit another page (such as the Home page)
#    assert flash.empty?  #verify that the flash message doesn't appear on the new page
#  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @user  #check the right redirect
    follow_redirect!  #visit the redirect page
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0		#check that the login link disappears verifying there are 0 login_path on the page
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path		#make a logout
    assert_not is_logged_in?
    assert_redirected_to root_url	#redirect to the home page
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path	#check that the login link reappears
    assert_select "a[href=?]", logout_path,      count: 0	#check that logout link disappear
    assert_select "a[href=?]", user_path(@user), count: 0	#check that profile link disappear
  end
  
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
  
end
