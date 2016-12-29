class AddCustomFieldsIsComputed < ActiveRecord::Migration
  def up
    add_column :custom_fields, :is_computed, :boolean, default: false
  end

  def down
    remove_column :custom_fields, :is_computed
  end
end
