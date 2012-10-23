class RenameColumnShowRange < ActiveRecord::Migration
  def up
    rename_column :pages, :show_range, :permission
  end

  def down
    rename_column :pages, :permission, :show_range
  end
end
