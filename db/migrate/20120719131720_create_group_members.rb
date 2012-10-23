class CreateGroupMembers < ActiveRecord::Migration
  def change
    create_table :group_members do |t|
      t.references :group
      t.references :user

      t.timestamps
    end
    add_index :group_members, :group_id
    add_index :group_members, :user_id
  end
end
