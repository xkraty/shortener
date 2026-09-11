require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = User.create!(email_address: "admin@example.com", password: "supersecretpass", admin: true)
    @user = User.create!(email_address: "chris@example.com", password: "supersecretpass")
  end

  def sign_in_as(user)
    post session_path, params: { email_address: user.email_address, password: "supersecretpass" }
  end

  test "requires sign-in like any other page" do
    get admin_root_path

    assert_redirected_to new_session_path
  end

  test "is not found for a signed-in non-admin" do
    sign_in_as(@user)

    get admin_root_path

    assert_response :not_found
  end

  test "shows every user and every link to an admin" do
    other_link = @user.links.create!(original_url: "https://example.com", slug: "hidden1")
    sign_in_as(@admin)

    get admin_root_path

    assert_response :success
    assert_match @user.email_address, response.body
    assert_match other_link.slug, response.body
  end

  test "the user count stat is a plain number, not a grouped count hash" do
    @user.links.create!(original_url: "https://example.com", slug: "hidden1")
    sign_in_as(@admin)

    get admin_root_path

    assert_select "p", text: User.count.to_s
  end
end
