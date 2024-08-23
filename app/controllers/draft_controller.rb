class DraftController < ApplicationController
  before_action :authenticate_user!

  def index
    @drafts = if params[:query].present? && params[:query] != ""
                  current_user.drafts.where("lower(title) ILIKE LOWER('%#{params[:query]}%')").order('created_at DESC')
                              .paginate(page: params[:page], per_page: 10)
                else
                  current_user.drafts.order('created_at DESC').paginate(page: params[:page], per_page: 10)
                end
    if params[:page].present? || params[:query].present? || params[:query] == ""
      render json: { entries: render_to_string(partial: 'draft/my_drafts', formats: [:html]) }
    end
  end

  def show
    @draft = Draft.find_by(id: params[:id])
    if @draft&.destroy
      flash[:notice] = "Draft Deleted Successfully"
      redirect_to '/draft'
    end
  end

  def create
    @draft = Draft.new(draft_params)
    if @draft.save
      render json: { blog_id: @draft.id, images_urls: @draft.details_images&.blobs&.map { |blob| blob.url } }
    end
  end

  def draft_details
    @draft = Draft.find_by(id: params[:id])
    if @draft.update(details: params[:details])
      render json: { message: 'Blog created successfully' }
    end
  end

  def bulk_delete
    ids = params[:ids].split(',')
    drafts = Draft.where(id: ids)
    count = drafts.count
    if drafts.destroy_all
      flash[:notice] = "#{count} Draft Deleted Successfully"
      redirect_to '/draft'
    end
  end

  private

  def draft_params
    params.permit(:title, :categories, :thumbnail, :description, details_images: []).merge(user_id: current_user.id)
  end
end
