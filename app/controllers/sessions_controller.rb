class SessionsController < ApplicationController
  require_unauthenticated_access except: :destroy

  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to new_session_path, alert: "Too many attempts. Try again in a few minutes." }

  def new
  end

  def create
    if (user = User.authenticate_by(email_address: email_address, password: password))
      start_new_session_for(user)
      redirect_to(session.delete(:return_to_after_authenticating) || root_path)
    else
      # One message for both cases — saying which half was wrong tells an
      # attacker which addresses exist.
      flash.now[:alert] = "Email or password didn't match."
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, notice: "Signed out."
  end

  private

  def email_address
    params.expect(:email_address)
  end

  def password
    params.expect(:password)
  end
end
