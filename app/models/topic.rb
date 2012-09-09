class Topic < ActiveRecord::Base
  attr_accessible :title, :user
  has_many :posts
end
