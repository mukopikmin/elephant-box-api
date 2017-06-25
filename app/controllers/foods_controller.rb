class FoodsController < ApplicationController
  before_action :set_food, only: [:show, :update, :destroy]
  before_action :authenticate_request!

  # GET /foods
  def index
    @foods = Food.all_with_invited(current_user)
    render json: @foods
  end

  # GET /foods/1
  def show
    if @food.is_owned_by(current_user)
      render json: @food
    else
      not_found
    end
  end

  # POST /foods
  def create
    @food = Food.new(food_params)

    if @food.is_owned_by(current_user) && @food.save
      render json: @food, status: :created, location: @food
    else
      bad_request
    end
  end

  # PATCH/PUT /foods/1
  def update
    if @food.is_owned_by(current_user) && @food.update(food_params)
      render json: @food
    else
      bad_request
    end
  end

  # DELETE /foods/1
  def destroy
    if @food.is_owned_by(current_user)
      @food.destroy
    else
      bad_request
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_food
    @food = Food.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def food_params
    params.permit(:name, :notice, :amount, :expiration_date, :box_id, :unit_id)
  end
end
