class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :slug
      t.bigint :parent_id
      t.integer :position

      t.timestamps
    end
  end
end
