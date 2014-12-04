class SessionsController < ApplicationController
	def create
		if user = User.authenticate(params[:email], params[:password])
			session[:user_id] = user.id
			redirect_to root_path, notice: 'Logeado'
		else
			flash.now[:alert] = 'Inicio de sesion incorrecto'
			render action: 'new'
		end
	end

	def destroy
		reset_session
		redirect_to root_path, notice: 'logout'
	end
end
