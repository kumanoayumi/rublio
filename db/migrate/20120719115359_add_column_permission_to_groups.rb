class AddColumnPermissionToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :permission, :string, default: "private"
  end
end
