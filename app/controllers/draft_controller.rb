class DraftController < ApplicationController
  before_action :authenticate_user!

  def create
    @draft = Draft.new(draft_params)
    if @draft.save
      render json: { blog_id: @draft.id, images_urls: @draft.details_images&.blobs&.map { |blob| blob.url } }
    end
  end

  def draft_details
    @draft = Blog.find_by(id: params[:id])
    if @draft.update(details: params[:details])
      render json: { message: 'Blog created successfully' }
    end
  end

  private

  def draft_params
    params.permit(:title, :categories, :thumbnail, :description, details_images: []).merge(user_id: current_user.id)
  end
end
