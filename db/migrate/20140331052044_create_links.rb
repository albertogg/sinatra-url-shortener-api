class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string  :uri
      t.string  :uri_hash
      t.integer :viewed

      t.timestamps
    end
  end
end
