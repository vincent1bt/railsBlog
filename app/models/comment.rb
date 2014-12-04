class Comment < ActiveRecord::Base
	after_create :email_article_author
	after_create :send_comment_email
	belongs_to :article

	validates :name, :body, presence: true
	validate :article_should_be_published

	def article_should_be_published
		error.add(:article_id, "is not published yet") if article && !article.published?
	end

	def email_article_author; end

	def send_comment_email
		Notifier.comment_added(self).deliver
	end
end
