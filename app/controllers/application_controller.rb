class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def flash_message(type, klass)
    t("models.#{type}", model: klass.model_name.human)
  end

  private

  def user_not_authorized
    flash[:alert] = t("not_authorized")
    redirect_to(request.referrer || root_path)
  end
end
