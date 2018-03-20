class Api::V1::UsersController < Api::ApplicationController
  before_action :authenticate_from_access_token

  # POST /api/v1/users
  def create
      #email: params[:email] || "#{params[:username]}@eff.org",
    @user = User.new(secure_params.merge(password: User.generate_password))

    if @user.save
      render json: { success: true, user: @user.to_json }, status: :created
    else
      render json: { success: false, errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/delete
  def destroy_by_email
    @user = User.where(email: params[:email]).first

    if @user and @user.destroy
      render json: { success: true }, status: :ok
    else
      render json: { success: false, errors: ['User not found'] }, status: :not_found
    end
  end

  private
  def secure_params
    params.require(:user).permit(
      :name, :email, :role, :title, :avatar, :team_id, :staff,
      { personal_emails: [] },
      { fabs_attributes: [:id, :gif_tag_file_name] }
    )
  end
end
