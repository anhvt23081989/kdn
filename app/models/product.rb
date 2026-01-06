class Product < ApplicationRecord
  belongs_to :category
  has_many_attached :images

  enum :status, { draft: 0, published: 1 }

  scope :published, -> { where(status: :published) }

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  # Rich tabs giống site: Mô tả / Thông số / HDSD
  has_rich_text :description
  has_rich_text :specification
  has_rich_text :manual
end
