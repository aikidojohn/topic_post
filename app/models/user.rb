class User < ActiveRecord::Base
  attr_accessible :email, :name, :twitter_image, :oauth_token, :oauth_token_secret
  has_many :topics
  has_many :posts
  
end
