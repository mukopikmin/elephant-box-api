class UsersController < ApplicationController
  before_action :set_user, only: [:show, :avatar, :update, :destroy]
  before_action :authenticate_request!, only: [:index, :avatar, :verify, :show, :search, :update]

  # GET /users
  def index
    if current_user.admin
      @users = User.all
      render json: @users
    else
      forbidden('Only administrator of this service is allowed.')
    end
  end

  # GET /users/verify
  def verify
    @user = current_user
    if @user.nil?
      not_found
    else
      render json: @user, include: []
    end
  end

  # GET /users/1
  def show
    if !accessible?
      forbidden('Access not allowed.')
    else
      render json: @user
    end
  end

  # GET /users/1/avatar
  def avatar
    if !accessible?
      forbidden('Access not allowed.')
    else
      send_data @user.avatar_file, type: @user.avatar_content_type, disposition: 'inline'
    end
  end

  # GET /users/search
  def search
    email = params[:email]
    @user = User.find_by_email(email)

    if @user.nil?
      not_found("Uesr #{email} does not exist.")
    else
      render json: @user
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      bad_request
    end
  end

  # PATCH/PUT /users/1
  def update
    if !accessible?
      forbidden('You can only update self.')
    elsif @user.update(user_params)
      render json: @user
    else
      bad_request
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    avatar = params[:avatar]
    unless avatar.nil?
      params[:avatar_file] = avatar.read
      params[:avatar_size] = params[:avatar_file].size
      params[:avatar_content_type] = avatar.content_type
    end
    params.permit(:name, :email, :password, :password_confirmation, :avatar_file, :avatar_size, :avatar_content_type)
  end

  def accessible?
    @user.id == current_user.id
  end
end
