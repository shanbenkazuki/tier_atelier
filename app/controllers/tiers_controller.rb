class TiersController < ApplicationController
  def index; end

  def new
    @categories = Category.all
  end

  def create
    redirect_to make_tiers_path
  end

  def search; end
end
