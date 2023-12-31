class UserPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def update?
    is_user?
  end

  def destroy?
    is_user?
  end

  private

  def is_user?
    record == user
  end
end
