class CreateGifts < ActiveRecord::Migration[8.1]
  def change
    create_table :gifts do |t|
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2
      t.string :link
      t.string :image
      t.references :user, null: false, foreign_key: true
      t.references :reserved_by, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
