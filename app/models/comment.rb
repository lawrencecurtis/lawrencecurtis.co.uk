class Comment < ActiveRecord::Base
  # association
  belongs_to :post
  
  # validation
  validates_presence_of :title
  validates_presence_of :body
  
  # defaults
  default_scope :order => 'created_at DESC'
end