class TierPolicy < ApplicationPolicy
  def new?
    user.present?
  end

  def create?
    new?
  end

  def show?
    true
  end

  def edit?
    user == record.user
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def arrange?
    edit?
  end

  def update_tier_cover_image?
    edit?
  end

  def create_from_template?
    edit?
  end
end
