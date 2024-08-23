class CommentsController < ApplicationController

  def index

  end

  def create
    @comment = Comment.new(comment_params)
    @comment.blog_id = params[:blog_id]
    if @comment.save
      render json: { entries: render_to_string(partial: 'blogs/comment', formats: [:html]),
                     child_comment: params[:parent_comment_id].present?, parent_comment_id: params[:parent_comment_id],
                     child_comment_count: @comment&.parent_comment&.child_comments&.count }
    end
  end

  def reactions
    @reaction = Reaction.find_by(comment_id: params[:comment_id], user_id: current_user.id, emoji_name: params[:emoji_name])
    if @reaction.present?
      @reaction.destroy
      render json: { destroy: true }
    else
      @reaction = Reaction.new(reaction_params)
      @reaction.comment_id = params[:comment_id]
      if @reaction.save
        render json: { reaction: @reaction, destroy: false }
      end
    end
  end

  private

  def comment_params
    params.permit(:comment_details, :parent_comment_id).merge(user_id: current_user.id)
  end

  def reaction_params
    params.permit(:emoji, :comment_id, :emoji_name).merge(user_id: current_user.id)
  end
end