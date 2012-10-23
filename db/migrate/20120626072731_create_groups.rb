class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :user_id
      t.string :name
      t.boolean :default_flag, default: false

      t.timestamps
    end
  end
end
