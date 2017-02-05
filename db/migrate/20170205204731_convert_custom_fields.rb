class ConvertCustomFields < ActiveRecord::Migration
  def up
    CustomField.all.each do |custom_field|
      if custom_field.format_store[:computed]
        sql = "UPDATE #{CustomField.table_name} SET "
        sql << "is_computed = 1 WHERE id = #{custom_field.id}"
        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end
end
