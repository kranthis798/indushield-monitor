class ApplicationPolicy
  attr_reader :user, :record
  RAILS_ADMIN_ACTIONS = [ :dashboard, :index, :show, :new, :edit, :destroy, :export, :history, :show_in_app ]

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def rails_admin?(action)
    p action
    if RAILS_ADMIN_ACTIONS.include?(action)
      user.admin? || user.super_admin?
    else
      raise ::Pundit::NotDefinedError, "unable to find policy #{action} for #{record}."
    end
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
