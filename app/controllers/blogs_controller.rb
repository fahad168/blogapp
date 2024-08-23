class BlogsController < ApplicationController
  before_action :authenticate_user!, only: :create

  def index; end

  def new
    @blog = Blog.find_by(id: params[:id]) if params[:id].present?
  end

  def edit
    @blog = if params[:key].present?
              Draft.find_by(id: params[:id])
            else
              Blog.find_by(id: params[:id])
            end
  end

  def create
    if params[:blog_id].present?
      @blog = Blog.find_by(id: params[:blog_id])
      if @blog.update(blog_params)
        render json: { blog_id: @blog.id, images_urls: @blog.details_images&.blobs&.map { |blob| blob.url } }
      end
    else
      @blog = Blog.new(blog_params)
      if @blog.save
        render json: { blog_id: @blog.id, images_urls: @blog.details_images&.blobs&.map { |blob| blob.url } }
      end
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

  def like
    @blog = Blog.find_by(id: params[:id])
    @like = Like.find_by(user_id: current_user.id, blog_id: @blog.id)
    if @like
      @like.destroy
      render json: { liked: false, likes_count: @blog.likes.count }, status: :ok
    else
      Like.create!(user_id: current_user.id, blog_id: @blog.id)
      render json: { liked: true, likes_count: @blog.likes.count }, status: :ok
    end
  end

  private

  def blog_params
    params.permit(:title, :categories, :thumbnail, :description, details_images: []).merge(user_id: current_user.id)
  end
end
