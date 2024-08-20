class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :log_in, :current_user, :logged_in?, :log_out

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if(user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def require_user
    if !logged_in?
      flash[:alert] = "ログインしてください。"
    end
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end
