class MyBlogsController < ApplicationController

  def index
    @my_blogs = if params[:query].present? && params[:query] != ""
                  current_user.blogs.where("lower(title) ILIKE LOWER('%#{params[:query]}%') AND deleted = ?", false).order('created_at DESC')
                              .paginate(page: params[:page], per_page: 10)
                else
                  current_user.blogs.where(deleted: false).order('created_at DESC').paginate(page: params[:page], per_page: 10)
                end
    if params[:page].present? || params[:query].present? || params[:query] == ""
      render json: { entries: render_to_string(partial: 'my_blogs/my_blogs', formats: [:html]) }
    end
  end

  def show
    @blog = Blog.find_by(id: params[:id])
    if @blog&.update(deleted: true)
      flash[:notice] = "Blog Deleted Successfully"
      redirect_to my_blogs_path
    end
  end

  def bulk_delete
    ids = params[:ids].split(',')
    blogs = Blog.where(id: ids)
    count = blogs.count
    if blogs.update_all(deleted: true)
      flash[:notice] = "#{count} Blogs Deleted Successfully"
      redirect_to my_blogs_path
    end
  end

end
