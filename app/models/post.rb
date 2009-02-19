class Post < ActiveRecord::Base
  # association 
  has_many :comments
  
  # validation
  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :body
  
  # defaults
  default_scope :order => 'created_at DESC'
  
  # scopes
  named_scope :recent, :conditions => { :limit => 5 }
  named_scope :published, :conditions => { :published => true }
  named_scope :unpublished, :conditions => { :published => false }
end