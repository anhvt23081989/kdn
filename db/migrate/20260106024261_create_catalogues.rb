class CreateCatalogues < ActiveRecord::Migration[8.1]
  def change
    create_table :catalogues do |t|
      t.string :title
      t.integer :year
      t.datetime :published_at

      t.timestamps
    end
  end
end
