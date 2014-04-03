class RemoveColumnViewedFromLinksTable < ActiveRecord::Migration
  def change
    remove_column :links, :viewed
  end
end
