require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email_address: "chris@example.com", password: "supersecretpass")
  end

  test "valid with an email and a password" do
    assert @user.valid?
  end

  test "requires an email address" do
    @user.email_address = nil

    assert_not @user.valid?
  end

  test "requires a unique email address" do
    @user.save!
    duplicate = User.new(email_address: "chris@example.com", password: "anothersecretpass")

    assert_not duplicate.valid?
  end

  test "normalizes the email address" do
    @user.email_address = "  Chris@Example.com  "
    @user.save!

    assert_equal "chris@example.com", @user.email_address
  end

  test "requires a password of at least 12 characters" do
    @user.password = "short"

    assert_not @user.valid?
  end

  test "is not an admin by default" do
    assert_not @user.admin?
  end

  test "authenticates with the right password" do
    @user.save!

    assert_equal @user, User.authenticate_by(email_address: @user.email_address, password: "supersecretpass")
  end
end
