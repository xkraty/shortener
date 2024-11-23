class Link < ApplicationRecord
  validates :original_url, presence: true
  validates :slug, uniqueness: true, presence: true

  def generate_slug
    loop do
      self.slug = SecureRandom.alphanumeric(6)

      break unless Link.exists?(slug:)
    end
  end

  def short_link
    @short_link ||= Rails.application.routes.url_helpers.short_url(slug, host: ENV.fetch("APP_HOST", "localhost:3000"))
  end
end
