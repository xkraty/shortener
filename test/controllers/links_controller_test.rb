require "test_helper"

class LinksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(email_address: "chris@example.com", password: "supersecretpass")
    @other_user = User.create!(email_address: "other@example.com", password: "supersecretpass")
    @link = @other_user.links.create!(original_url: "https://example.com", slug: "other1")
  end

  def sign_in_as(user)
    post session_path, params: { email_address: user.email_address, password: "supersecretpass" }
  end

  test "index shows a landing page when signed out" do
    get root_path

    assert_response :success
    assert_select "a[href=?]", new_session_path
    assert_select "a[href=?]", new_registration_path
  end

  test "index only shows the current user's links" do
    own_link = @user.links.create!(original_url: "https://example.com", slug: "mine12")
    sign_in_as(@user)

    get root_path

    assert_response :success
    assert_match own_link.slug, response.body
    assert_no_match @link.slug, response.body
  end

  test "create requires sign-in" do
    post links_path, params: { link: { original_url: "https://example.com" } }

    assert_redirected_to new_session_path
  end

  test "create assigns the new link to the current user" do
    sign_in_as(@user)

    assert_difference "@user.links.count", 1 do
      post links_path, params: { link: { original_url: "https://example.com" } }
    end
  end

  test "redirect works without signing in and counts a click" do
    assert_difference "@link.reload.clicks", 1 do
      get short_path(@link.slug)
    end

    assert_redirected_to @link.original_url
  end
end
