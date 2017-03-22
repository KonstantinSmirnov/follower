class Webpage < ApplicationRecord
  require 'securerandom'

  before_validation :add_token

  validates :url, presence: true
  validates :name, presence: true
  validates :widget_token, presence: true

  belongs_to :user

  private

  def add_token
    self.widget_token = SecureRandom.hex if self.widget_token.blank?
  end

end
