class BoxesController < ApplicationController
  before_action :set_box, only: [:show, :units, :update, :destroy, :invite, :deinvite]
  before_action :authenticate_user

  # GET /boxes
  def index
    @boxes = Box.all_with_invited(current_user)
    render json: @boxes
  end

  # GET /boxes/owns
  def owns
    @boxes = Box.owned_by(current_user)
    render json: @boxes
  end

  # GET /boxes/invited
  def invited
    @boxes = Box.inviting(current_user)
    render json: @boxes
  end

  # GET /boxes/1
  def show
    if @box.is_owned_by(current_user)
      render json: @box, include: [:user, { foods: :unit }]
    else
      forbidden
    end
  end

  # GET /boxes/1/units
  def units
    @units = @box.user.units
    if @box.is_accesable(current_user)
      render json: @units
    else
      forbidden
    end
  end

  # POST /boxes
  def create
    @box = Box.new(box_params)

    if @box.save
      render json: @box, status: :created, location: @box
    else
      render json: @box.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /boxes/1
  def update
    if @box.is_owned_by(current_user)
      if @box.update(box_params)
        render json: @box
      else
        render json: @box.errors, status: :unprocessable_entity
      end
    else
      forbidden
    end
  end

  # DELETE /boxes/1
  def destroy
    if @box.is_owned_by(current_user)
      @box.destroy
    else
      forbidden
    end
  end

  # POST /boxes/1/invite
  def invite
    @invitation = Invitation.new(invitatation_params)

    if Invitation.exists?(invitatation_params.to_h)
      bad_request
    elsif @box.is_owned_by(current_user)
      if @invitation.save
        render json: @invitation, status: :created
      else
        render json: @invitation.errors, status: :unprocessable_entity
      end
    else
      forbidden
    end
  end

  # DELETE /boxes/1/invite
  def deinvite
    @invitation = Invitation.find_by(user: current_user, box: @box)
    if @invitation.nil?
      not_modified
    else
      @invitation.destroy
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_box
    @box = Box.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def box_params
    params[:user_id] = current_user.id
    params.permit(:name, :notice, :user_id)
  end

  def invitatation_params
    params[:box_id] = params[:id]
    params.permit(:box_id, :user_id)
  end
end
