class MembersOnlyArticlesController < ApplicationController
  before_action :authorize_user, only: [:index, :show]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.where(is_member_only: true)
    render json: articles
  end

  def show
    article = Article.find_by(id: params[:id], is_member_only: true)
    if article
      render json: article
    else
      render json: { error: "Article not found" }, status: :not_found
    end
  end

  private

  def authorize_user
    if session[:user_id].nil?
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end
end
