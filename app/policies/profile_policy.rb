class ProfilePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(:memberships).where(memberships: { organisation: user.profile.organisations })
    end
  end

  alias :profile :record

  def show?
    user_owns_profile || user_belongs_to_same_organisation
  end

  def create?
    user_is_admin
  end

  def update?
    user_owns_profile || user_is_admin_in_profile_organisation
  end

  alias :destroy? :create?

  private

  def user_owns_profile
    user.profile.id == profile.id
  end

  def user_belongs_to_same_organisation
    user.profile.organisation == profile.organisation
  end

  def user_is_admin_in_profile_organisation
    user_belongs_to_same_organisation &&
    user.permissions.exists?(organisation: profile.organisation, role: admin_role)
  end

  def user_is_admin
    user.permissions.exists?(role: admin_role)
  end
end
