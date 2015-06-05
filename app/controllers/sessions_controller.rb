class SessionsController < ApplicationController
  
  def new
  end
  
  def create
	  user = User.find_by(email: params[:session][:email].downcase)
	  if user && user.authenticate(params[:session][:password])
        # Log the user in and redirect to the user's show page.
        log_in user  #helper method for save session
        
		#Remember me checkbox
        if params[:session][:remember_me] == '1'
	      remember(user)
	    else
	      forget(user)
	    end
		# Equivalent to: params[:session][:remember_me] == '1' ? remember(user) : forget(user)

		redirect_back_or user
      else
        # Create an error message.
        flash.now[:danger] = 'Invalid email/password combination' # Using flash.now I prevent the flash message to appear also on other page
        render 'new'
      end
  end
  
  def destroy
	log_out if logged_in?
    redirect_to root_url
  end
  
end
