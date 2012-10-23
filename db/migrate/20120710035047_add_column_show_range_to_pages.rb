class AddColumnShowRangeToPages < ActiveRecord::Migration
  def change
    add_column :pages, :show_range, :string, default: "private"
  end
end
