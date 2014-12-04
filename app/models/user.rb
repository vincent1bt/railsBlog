require 'digest'
class User < ActiveRecord::Base
	attr_accessor :password

	before_save :encrypt_new_password

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
	validates_confirmation_of :password
	validates :password, presence: true#, if => :password_required?


	has_one :profile
	has_many :articles, -> { order('id DESC, title ASC') },
							:dependent => :destroy
	has_many :replies, :through => :articles, :source => :comments

	def self.authenticate(email, password)
		user = find_by_email(email)
		return user if user && user.authenticated?(password)
	end

	def authenticated?(password)
		self.hashed_password == encrypt(password)
	end

	protected
		def encrypt_new_password
			return if password.blank?
			self.hashed_password = encrypt(password)
		end

		def password_required?
			hashed_password.blank? || password.present?
		end

		def encrypt(string)
			Digest::SHA1.hexdigest(string)
		end
end

