class ConvertCustomFields < ActiveRecord::Migration
  def up
    fields = CustomField.where(field_format: 'computed')
    fields.each do |field|
      field.update_attribute(:formula, field.format_store[:formula])
      format = case field.format_store[:output_format]
               when 'integer'
                 'int'
               when 'percentage'
                 'float'
               else
                 field.format_store[:output_format]
               end
      sql = "UPDATE #{CustomField.table_name} SET "
      sql << "is_computed = '1', field_format = '#{format}' WHERE id = #{field.id}"
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
