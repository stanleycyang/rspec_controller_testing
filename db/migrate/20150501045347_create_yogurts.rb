class CreateYogurts < ActiveRecord::Migration
  def change
    create_table :yogurts do |t|
      t.string :name
      t.integer :calories

      t.timestamps null: false
    end
  end
end
