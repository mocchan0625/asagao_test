class ArticlesController < ApplicationController
  before_action :login_required, except: [:index, :show]

  # 記事一覧
  def index
    @articles = Article.order("released_at DESC")
  end

  # 記事詳細
  def show
    @article = Article.find(params[:id])
  end

  # 新規登録フォーム
  def new
    @article = Article.new
  end

  # 編集フォーム
  def edit
    @article = Article.find(params[:id])
  end

  # 新規作成
  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article, notice: "ニュース記事を登録しました。"
    else
      render "new"
    end
  end

  # 更新
  def update
    @article = Article.find(params[:id])
    @article.assign_attributes(article_params)
    if @article.save
      redirect_to @article, notice: "ニュース記事を更新しました。"
    else
      render "edit"
    end
  end

  # 削除
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to :articles
  end

  private
  def article_params
    attrs = [:title, :body, :released_at, :expired_at]
    attrs << :member_only if current_member.administrator?
    params.require(:article).permit(attrs)
  end
end
