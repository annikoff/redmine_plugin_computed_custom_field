class ConvertCustomFields < ActiveRecord::Migration
  def up
    fields = CustomField.where(field_format: 'computed')
    fields.each do |field|
      format = case field.format_store[:output_format]
               when 'integer'
                 'int'
               when 'percentage'
                 'float'
               else
                 field.format_store[:output_format]
               end
      formula = field.format_store[:formula]
      sql = "UPDATE #{CustomField.table_name} SET "
      sql << "is_computed = '1', field_format = '#{format}', formula = '#{formula}'  WHERE id = #{field.id}"
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
