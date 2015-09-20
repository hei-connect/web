# encoding: utf-8
class UsersController < ApplicationController
  layout 'public'
  before_filter :require_login, only: :validate

  def create
    fail!
    params[:user][:ecampus_id].downcase! if params[:user][:ecampus_id]
    @user = User.new(params[:user])

    if User.where(ecampus_id: @user.ecampus_id).any?
      user_db = User.find_by_ecampus_id @user.ecampus_id
      if user_db.authenticate @user.password

        if Feature.user_login_enabled?
          session[:user_id] = user_db.id
          redirect_to root_url
        else
          redirect_to root_url, alert: Feature.user_login_error_message
        end
      else
        flash.now[:alert] = 'Identifiants erronés'
        render 'welcome/index'
      end
    else
      if Feature.user_registration_enabled?
        if @user.save
          session[:user_id] = @user.id
          Delayed::Job.enqueue CheckUserWorker.new(@user.id, @user.ecampus_id, @user.password),
                               priority: ApplicationWorker::PR_CHECK_USER,
                               queue: ApplicationWorker::QUEUE_REGULAR
          redirect_to validate_users_url
        else
          render 'welcome/index'
        end
      else
        redirect_to root_url, alert: Feature.user_registration_error_message
      end
    end
  end

  def validate
    case current_user.user_state
      when Update::STATE_OK
        redirect_to root_url, notice: "Les identifiants de votre compte ont été validés."
      when Update::STATE_FAILED, Update::STATE_UNKNOWN
        current_user.destroy
        session[:user_id] = nil
        redirect_to root_url, alert: "Les identifiants que vous avez entré ne permettent pas de vous connecter" +
            " à e-campus, ou bien e-campus ne répond pas. Le compte a été supprimé, merci de ré-essayer."
    end
  end
end
