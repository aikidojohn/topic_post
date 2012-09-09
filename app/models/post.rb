class Post < ActiveRecord::Base
  attr_accessible :content, :topic_id, :user
  belongs_to :topic
  
end
