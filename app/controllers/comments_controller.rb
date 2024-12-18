# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: t('activerecord.models.comments'))
    else
      redirect_to @commentable, notice: t('controllers.common.notice_error', name: t('activerecord.models.comments'))
    end
  end

  def destroy
    return unless current_user.id == @comment.user_id

    @comment.destroy

    redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: t('activerecord.models.comments'))
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
