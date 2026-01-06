class Post < ApplicationRecord
  belongs_to :category, optional: true
  has_one_attached :cover
  has_rich_text :content

  validates :title, :slug, presence: true
  validates :slug, uniqueness: true

  scope :published, -> { where("published_at IS NULL OR published_at <= ?", Time.current) }
end
