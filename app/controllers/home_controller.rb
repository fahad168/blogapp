class HomeController < ApplicationController
  def index
    @blogs = Blog.all.paginate(per_page: 3, page: params[:page])
    @categories = Blog.pluck(:categories)&.map { |category| JSON.parse(category) }&.flatten
    if params[:page].present?
      render json: { entries: render_to_string(partial: 'home/index_blogs', formats: [:html]) }
    else
      @slider = Blog.all.shuffle
    end
  end
end
