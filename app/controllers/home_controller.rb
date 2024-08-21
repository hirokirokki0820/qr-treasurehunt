class HomeController < ApplicationController

  def top
    if current_user
      redirect_to current_user
    end
  end

  def index
  end

  def host_user
  end
end
