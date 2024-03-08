class BlogsController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def create
    @blog = Blog.new(blog_params)
    if @blog.save
      render json: { blog_id: @blog.id, images_urls: @blog.details_images&.blobs&.map { |blob| blob.url } }
    end
  end

  def blog_details
    @blog = Blog.find_by(id: params[:id])
    if @blog.update(description: params[:description])
      render json: { message: 'blog created successfully' }
    end
  end

  private

  def blog_params
    params.permit(:title, :categories, details_images: []).merge(user_id: current_user.id)
  end
end
