class StoresController < ApplicationController
  before_action :authenticate_user!

  def index
    @stores = Store.all.order('created_at DESC')
  end

  def new
    @store = Store.new
  end

  def create

  end

  private

  def store_params
    params.permit(:title, :description, :store_icon, :status, product_categories: []).merge(user_id: current_user.id)
  end
end
