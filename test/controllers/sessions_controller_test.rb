require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(email_address: "chris@example.com", password: "supersecretpass")
  end

  test "signs in with valid credentials" do
    post session_path, params: { email_address: @user.email_address, password: "supersecretpass" }

    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "rejects invalid credentials without revealing which field was wrong" do
    post session_path, params: { email_address: @user.email_address, password: "wrongpassword" }

    assert_response :unprocessable_content
    assert_match(/didn't match/, flash[:alert])
  end

  test "signing out clears the session" do
    post session_path, params: { email_address: @user.email_address, password: "supersecretpass" }
    delete session_path

    assert_redirected_to new_session_path
    get root_path
    assert_redirected_to new_session_path
  end
end
