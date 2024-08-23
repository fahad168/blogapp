class AddDeletedToBlogs < ActiveRecord::Migration[7.0]
  def change
    add_column :blogs, :deleted, :boolean, default: false
  end
end
