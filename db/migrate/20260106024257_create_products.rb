class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name
      t.string :slug
      t.string :sku
      t.integer :status
      t.boolean :featured
      t.jsonb :properties

      t.timestamps
    end
  end
end
