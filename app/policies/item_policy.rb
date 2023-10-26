class ItemPolicy < ApplicationPolicy
  def update?
    user == record.user
  end

  def destroy?
    update?
  end
end
