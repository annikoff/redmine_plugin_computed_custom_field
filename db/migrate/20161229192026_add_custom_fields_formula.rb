class AddCustomFieldsFormula < PLUGIN_MIGRATION_CLASS
  def up
    add_column :custom_fields, :formula, :text
  end

  def down
    remove_column :custom_fields, :formula
  end
end
