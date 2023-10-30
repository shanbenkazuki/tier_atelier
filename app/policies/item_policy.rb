class ItemPolicy < ApplicationPolicy
  def update?
    user == record.tier.user
  end

  def destroy?
    update?
  end
end
