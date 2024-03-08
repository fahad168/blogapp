class RegistrationsController < Devise::RegistrationsController
  before_action :check_email_present, only: :create

  def create
    @user = User.new(sign_up_params)
    if @user.save
      flash[:notice] = "Account Created Successfully"
      redirect_to new_user_session_path
    else
      flash[:alert] = @user.errors.full_messages.first
      redirect_to new_user_session_path
    end
  end

  private

  def sign_up_params
    params.permit(:username, :email, :password, :password_confirmation)
  end

  def check_email_present
    @user = User.find_by(email: params[:email])

    if @user.present?
      flash[:alert] = 'Email Already Taken'
      return redirect_to new_user_registration_path
    end
  end
end
