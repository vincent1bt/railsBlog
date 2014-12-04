class ArticlesController < ApplicationController
	before_action :set_article, only: [:show, :edit, :update, :destroy]
	before_action :authenticate, except: [:index, :show]

	def index
		@articles = Article.all
	end

	def show
	end

	def new
		@article = Article.new
	end

	def create
		@article = current_user.articles.new(article_params)
		if @article.save
			redirect_to @article
		else
			render action: 'new'
		end
	end

	def edit
		@article = current_user.articles.new(article_params)
	end

	def update
		@article = current_user.articles.find(params[:id])
		if @article.update(article_params)
			redirect_to @article, notice: "Article updated"
		else
			render action: "edit"
		end
	end

	def destroy
		@article = current_user.articles.find(params[:id])
		@article.destroy
		redirect_to articles_url
	end

	def notify_friend
    	@article = Article.find(params[:id])
    	Notifier.email_friend(@article, params[:name], params[:email]).deliver
    	redirect_to @article, notice: 'El mensaje se ha enviado'
  	end

	
	private
		def set_article
			@article = Article.find(params[:id])
		end

		def article_params
			params.require(:article).permit(:title, :body, :category_ids => [])
		end
end
