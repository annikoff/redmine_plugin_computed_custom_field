class ConvertCustomFields < ActiveRecord::Migration
  def up
    fields = CustomField.where(field_format: 'computed')
    return if fields.blank?
    fields.each do |field|
      format = case field.format_store[:output_format]
               when 'integer'
                 'int'
               when 'percentage'
                 'bool'
               else
                 field.format_store[:output_format]
               end
      sql = "UPDATE #{CustomField.table_name} SET "
      sql << "is_computed = '1', field_format = '#{format}'  WHERE id = #{field.id}"
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
