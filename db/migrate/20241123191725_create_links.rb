class CreateLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :links do |t|
      t.string :original_url, null: false
      t.string :slug, null: false
      t.integer :clicks, default: 0

      t.timestamps
    end

    add_index :links, :slug, unique: true
  end
end
