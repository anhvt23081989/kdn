class CreateLeads < ActiveRecord::Migration[8.1]
  def change
    create_table :leads do |t|
      t.string :source
      t.string :name
      t.string :address
      t.string :phone
      t.string :email
      t.text :message

      t.timestamps
    end
  end
end
