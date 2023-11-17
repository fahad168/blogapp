class RegistrationsController < Devise::RegistrationsController
  before_action :check_email_present, only: :create

  def create
    if params[:user][:password].length >= set_minimum_password_length
      if params[:user][:password] != params[:user][:password_confirmation]
        flash[:alert] = 'Password Confirmation Not Matched'
        redirect_to new_user_registration_path
      else
        build_resource(sign_up_params)
        flash[:notice] = "Account Created Successfully"
        redirect_to new_user_session_path
      end
    else
      flash[:alert] = 'Password length must be at least 6 characters'
      redirect_to new_user_registration_path
    end
    # email = params[:user][:email].split('@')
    # if email.length != 2 || email[1].include?('.') == false
    #   flash[:alert] = 'Email is Invalid'
    #   return redirect_to new_user_registration_path
    # end
    # build_resource(sign_up_params)
    # resource.save
    # yield resource if block_given?
    # if resource.persisted?
    #   if resource.active_for_authentication?
    #     flash[:success] = 'Account Created Successfully'
    #     redirect_to new_user_session_path
    #   end
    # elsif params[:user][:password].length >= set_minimum_password_length
    #   if params[:user][:password] != params[:user][:password_confirmation]
    #     flash[:not_match] = 'Password Confirmation Not Matched'
    #     redirect_to new_user_registration_path
    #   end
    # else
    #   flash[:length] = 'Password length must be at least 6 characters'
    #   redirect_to new_user_registration_path
    # end
  end

  private

  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def check_email_present
    @user = User.find_by(email: params[:user][:email])

    if @user.present?
      flash[:alert] = 'Email Already Taken'
      return redirect_to new_user_registration_path
    end
  end
end
