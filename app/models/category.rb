class Category < ApplicationRecord
    has_many :products, dependent: :restrict_with_error
    belongs_to :parent, class_name: "Category", optional: true
    has_many :children, class_name: "Category", foreign_key: :parent_id, dependent: :nullify
  
    validates :name, presence: true
    validates :slug, presence: true, uniqueness: true
  
    has_one_attached :cover_image
  end
  