class RegistrationsController < ApplicationController
  require_unauthenticated_access

  rate_limit to: 5, within: 15.minutes, only: :create,
             with: -> { redirect_to new_registration_path, alert: "Too many attempts. Try again in a few minutes." }

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      start_new_session_for(@user)
      redirect_to root_path, notice: "Welcome — your account is ready."
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def user_params
    params.expect(user: [ :email_address, :password, :password_confirmation ])
  end
end
