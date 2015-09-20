module Dashboard
  class UsersController < DashboardController

    def show
      @user = current_user
    end

    attr_accessor :user
    helper_method :user

  end
end
