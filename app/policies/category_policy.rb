class CategoryPolicy < ApplicationPolicy
  def update?
    admin_or_owner?
  end

  def destroy?
    admin_or_owner?
  end

  private

  def admin_or_owner?
    user.admin? || record.user_id == user.id
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
