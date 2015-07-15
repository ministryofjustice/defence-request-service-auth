class WelcomeController < ApplicationController
  def index
    render plain: "You made it!"
  end
end
