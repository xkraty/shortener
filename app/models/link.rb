class Link < ApplicationRecord
  validates :original_url, presence: true
  validates :slug, uniqueness: true

  def generate_slug
    loop do
      self.slug = SecureRandom.alphanumeric(6)

      break unless Link.exists?(slug:)
    end
  end

  def short_url = @short_url ||= "#{ENV.fetch("APP_URL", "localhost/")}/#{slug}"
end
