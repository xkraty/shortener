class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :links, dependent: :nullify

  normalizes :email_address, with: ->(value) { value.strip.downcase.presence }

  validates :email_address, presence: true, uniqueness: true,
                            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 12 }, allow_nil: true
end
