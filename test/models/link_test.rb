require "test_helper"

class LinkTest < ActiveSupport::TestCase
  def setup
    @link = Link.new(original_url: "https://example.com")
  end

  test "should be valid without slug" do
    assert @link.invalid?
  end

  test "should require original url" do
    @link.original_url = nil

    assert_not @link.valid?
    assert_includes @link.errors[:original_url], "can't be blank"
  end

  test "should generate unique slug" do
    @link.generate_slug

    assert_not_nil @link.slug
    assert_equal 6, @link.slug.length
  end

  test "should ensure unique slugs" do
    mock = Minitest::Mock.new
    mock.expect(:call, "diff3r", [ 6 ])

    link1 = Link.create!(original_url: "https://example.com", slug: "chris8")
    link2 = Link.new(original_url: "https://another-example.com")

    SecureRandom.stub(:alphanumeric, mock) do
      link2.generate_slug
    end

    assert_not_equal link1.slug, link2.slug
  end

  test "should generate short url" do
    @link.slug = "abc123"
    expected_url = "#{ENV.fetch("APP_URL", "http://localhost:3000")}/abc123"

    assert_equal expected_url, @link.short_link
  end

  test "should memoize short url" do
    original_host = ENV["APP_HOST"]

    @link.slug = "abc123"
    first_call = @link.short_link

    ENV["APP_HOST"] = "different-url"
    second_call = @link.short_link

    assert_equal first_call, second_call

    ENV["APP_HOST"] = original_host
  end
end
