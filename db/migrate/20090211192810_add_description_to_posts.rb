class AddDescriptionToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :description, :text
  end

  def self.down
    remove_column :posts, :description
  end
end
