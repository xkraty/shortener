require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "creates an account and signs the user in" do
    assert_difference "User.count", 1 do
      post registration_path, params: { user: {
        email_address: "new@example.com",
        password: "supersecretpass",
        password_confirmation: "supersecretpass"
      } }
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "does not create an account when passwords don't match" do
    assert_no_difference "User.count" do
      post registration_path, params: { user: {
        email_address: "new@example.com",
        password: "supersecretpass",
        password_confirmation: "somethingelse"
      } }
    end

    assert_response :unprocessable_content
  end
end
