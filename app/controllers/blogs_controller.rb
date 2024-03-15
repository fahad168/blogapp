class BlogsController < ApplicationController
  before_action :authenticate_user!, only: :create

  def index; end

  def create
    @blog = Blog.new(blog_params)
    if @blog.save
      render json: { blog_id: @blog.id, images_urls: @blog.details_images&.blobs&.map { |blob| blob.url } }
    end
  end

  def show
    @blog = Blog.friendly.find(params[:id])
  end

  def blog_details
    @blog = Blog.find_by(id: params[:id])
    if @blog.update(details: params[:details])
      render json: { message: 'Blog created successfully' }
    end
  end

  def suggestions
    @suggestions = GoogleSuggest.suggest_for params[:word]
    render json: { entries: render_to_string(partial: 'blogs/suggestions', formats: [:html]) }
  end

  private

  def blog_params
    params.permit(:title, :categories, :thumbnail, :description, details_images: []).merge(user_id: current_user.id)
  end
end
