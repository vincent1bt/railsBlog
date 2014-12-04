class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  	def current_user#Retorna el usuario logeado o da false si no hay ninguno
  		return unless session[:user_id]
  		@current_user ||= User.find_by_id(session[:user_id])
  	end

  	helper_method :current_user #hace el usuario actual un metodo

  	def authenticate
  		logged_in? || access_denied
  	end

  	def logged_in?
  		current_user.is_a? User
  	end

  	helper_method :logged_in?

  	def access_denied
  		redirect_to login_path, notice: 'Porfavor inicia sesion' and return false
  	end


end
