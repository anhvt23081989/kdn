class Lead < ApplicationRecord
    validates :name, :phone, :email, presence: true
  end
  