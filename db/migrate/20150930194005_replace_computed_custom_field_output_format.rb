class ReplaceComputedCustomFieldOutputFormat < ActiveRecord::Migration
  def up
    cfs = CustomField.where field_format: 'computed'
    cfs.each do |cf|
      if cf.format_store[:output_format] == 'int'
        cf.format_store[:output_format] = 'integer'
        cf.save!
      end
    end
  end

  def down
    cfs = CustomField.where field_format: 'computed'
    cfs.each do |cf|
      if cf.format_store[:output_format] == 'integer'
        cf.format_store[:output_format] = 'int'
        cf.save!
      end
    end
  end
end
