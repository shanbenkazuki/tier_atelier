class TiersController < ApplicationController
  def index; end

  def new
    @categories = Category.all
  end

  def search; end
end
