class ConvertCustomFields < ActiveRecord::Migration
  def up
    fields = CustomField.all.select { |cf| cf.format_store[:computed] }
    return if fields.blank?
    ids = fields.map(&:id).join(',')
    sql = "UPDATE #{CustomField.table_name} SET "
    sql << "is_computed = '1' WHERE id IN (#{ids})"
    ActiveRecord::Base.connection.execute(sql)
  end
end
