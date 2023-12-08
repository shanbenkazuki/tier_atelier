class ItemPolicy < ApplicationPolicy
  def update?
    is_owner?
  end

  def destroy?
    is_owner?
  end

  private

  def is_owner?
    user == record.tier.user
  end
end
