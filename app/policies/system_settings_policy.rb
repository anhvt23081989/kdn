class SystemSettingsPolicy < ApplicationPolicy
  def menu?
    admin?
  end
end

