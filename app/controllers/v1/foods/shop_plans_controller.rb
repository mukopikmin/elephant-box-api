# frozen_string_literal: true

class V1::Foods::ShopPlansController < V1::ApplicationController
  before_action :authenticate_request!
  before_action :set_food, only: %i[index create]

  # GET /foods/1/shop_plans
  def index
    if !accessible?
      not_found
    else
      render json: @food.shop_plans
    end
  end

  # POST /foods/1/shop_plans
  def create
    @shop_plan = ShopPlan.new(shop_plan_params)
    @shop_plan.food = @food

    if !accessible?
      forbidden
    elsif @shop_plan.save
      render json: @shop_plan, status: :created
    else
      bad_request
    end
  end

  private

  def set_food
    @food = Food.find(params[:food_id])
  end

  def accessible?
    @food.box.accessible_for?(current_user)
  end

  def shop_plan_params
    params.permit(:notice, :done, :date, :amount)
  end
end
