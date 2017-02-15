module MethodsHelper
  def issue
    Issue.find 3
  end

  def project
    Project.find 1
  end

  def field_with_string_format
    computed_field 'string'
  end

  def field_with_list_format
    computed_field 'list', possible_values: %w(Stable Beta Alpha)
  end

  def field_with_float_format
    computed_field 'float'
  end

  def field_with_int_format
    computed_field 'int'
  end

  def field_with_bool_format
    computed_field 'bool'
  end

  def field_with_date_format
    computed_field 'date'
  end

  def field_with_user_format
    computed_field 'user'
  end

  def field_with_link_format
    computed_field 'link'
  end

  def computed_field(format, attributes = {})
    params = attributes.merge(name: format, is_computed: true,
                              field_format: format, is_for_all: true)
    field = IssueCustomField.create params
    field.trackers << Tracker.first if field.is_a? IssueCustomField
    field
  end
end
