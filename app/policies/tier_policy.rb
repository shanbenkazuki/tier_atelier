class TierPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def edit?
    is_owner?
  end

  def update?
    is_owner?
  end

  def destroy?
    is_owner?
  end

  def update_tier_cover_image?
    is_owner?
  end

  private

  def is_owner?
    user == record.user
  end
end
