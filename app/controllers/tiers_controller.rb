class TiersController < ApplicationController
  def index; end

  def new
    @categories = Category.all
    @tier_list = TierList.new
  end

  def create
    ActiveRecord::Base.transaction do
      # binding.pry
      @tier_list = current_user.tier_lists.create!(tier_list_params)
      1.upto(5) do |i|
        @tier_list.tiers.create!(horizontal_name: params["tier_list"]["horizontal_label_#{i}"], vertical_name: params["tier_list"]["vertical_label_#{i}"], horizontal_order: i, vertical_order: i)
      end
    end
    redirect_to make_tiers_path, success: t('.success')
  rescue => e
    # binding.pry
    @categories = Category.all
    flash.now[:danger] = t('.fail')
    render :new, status: :unprocessable_entity
  end

  def search; end

  private

  def tier_list_params
    params.require(:tier_list).permit(:category_id, :title, :description, images: [])
  end
end
