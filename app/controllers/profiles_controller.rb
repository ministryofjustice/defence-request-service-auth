class ProfilesController < ApplicationController
  before_action :find_profile, only: [:show, :destroy]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @profiles = policy_scope(Profile)
  end

  def show
    authorize profile_form
  end

  def new
    authorize profile_form
  end

  def edit
    authorize profile_form
  end

  def create
    profile_form.create(profile_params)

    authorize profile_form

    if profile_form.save
      redirect_to profile_path(profile_form), notice: flash_message(:create, Profile)
    else
      render :new
    end
  end

  def update
    profile_form.update(profile_params)

    authorize profile_form

    if profile_form.save
      redirect_to(profile_path(profile_form), notice: flash_message(:update, Profile))
    else
      render :edit
    end
  end

  def destroy
    authorize find_profile

    if find_profile.destroy
      redirect_to profiles_path, notice: flash_message(:destroy, Profile)
    else
      redirect_to profiles_path, notice: flash_message(:failed_destroy, Profile)
    end
  end

  private

  def find_profile
    @profile ||= load_profile
  end

  def load_profile
    if params[:id]
      Profile.find params[:id]
    else
      Profile.new organisations: [current_user.organisation]
    end
  end

  def find_profile_user
    find_profile.try(:user) || User.new
  end

  def profile_form
    @profile_form ||= ProfileForm.new profile: find_profile, user: find_profile_user
  end

  def profile_params
    params.require(:profile).permit(:name,
                                    :tel,
                                    :mobile,
                                    :address,
                                    :postcode,
                                    :email,
                                    :has_associated_user,
                                    :password,
                                    :password_confirmation)
  end
end
