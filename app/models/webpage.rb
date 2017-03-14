class Webpage < ApplicationRecord

  validates :url, presence: true
  validates :name, presence: true

  belongs_to :user
end
