class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :failure]

  def create
    # This is needed to fetch the current_user object
    session[:user_token] = auth_hash.fetch(:credentials).fetch(:token)

    redirect_to root_url
  end

  def failure
    render plain: "Unable to be authenticated."
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end
end
