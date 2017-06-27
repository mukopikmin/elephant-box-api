class UnitsController < ApplicationController
  before_action :set_unit, only: [:show, :update, :destroy]
  before_action :authenticate_request!

  # GET /units
  def index
    @units = Unit.owned_by(current_user)

    render json: @units
  end

  # GET /units/1
  def show
    if owner_of_unit?
      render json: @unit
    else
      not_found('You do not have dpecified unit.')
    end
  end

  # POST /units
  def create
    @unit = Unit.new(unit_params)

    if duplicate_unit?
      bad_request('Specified label of unit already exists.')
    elsif @unit.save
      render json: @unit, status: :created, location: @unit
    else
      bad_request('Could not persite the unit.')
    end
  end

  # PATCH/PUT /units/1
  def update
    if !owner_of_unit?
      bad_request('You can not update this unit.')
    elsif duplicate_unit?
      bad_request('Specified label of unit already exists.')
    elsif @unit.update(unit_params)
      render json: @unit
    else
      bad_request
    end
  end

  # DELETE /units/1
  def destroy
    if !owner_of_unit?
      bad_request('You can not destroy this unit.')
    else
      @unit.destroy
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def unit_params
      params[:user_id] = current_user.id
      params.permit(:label, :step, :user_id)
    end

    def owner_of_unit?
      @unit.is_owned_by(current_user)
    end

    def duplicate_unit?
      current_user.has_unit_labeled_with(unit_params[:label])
    end
end
