class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  # Roles
  enum :role, {
    guest: 0,
    admin: 1
  }

  # Set default role
  after_initialize :set_default_role, if: :new_record?

  # Avatar attachment
  has_one_attached :avatar

  # Scopes (enum already provides these, but we can add custom ones if needed)
  scope :admins, -> { where(role: :admin) }
  scope :guests, -> { where(role: :guest) }

  private

  def set_default_role
    self.role ||= :guest
  end
end
