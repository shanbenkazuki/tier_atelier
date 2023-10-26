class TemplatePolicy < ApplicationPolicy
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
    is_user?
  end

  def update?
    is_user?
  end

  def destroy?
    is_user?
  end

  private

  def is_user?
    user == record.user
  end
end
