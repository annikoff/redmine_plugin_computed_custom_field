### ComputedCustomField plugin for Redmine

### Description:
This plugin adds new type of Custom Field named "computed".
Value of computed field can be set by formula.
In formula constructions like %{cf_id} are replaced by IDs of custom fields.
Valid formula is a valid Ruby code executed when customized object is updated.

> ### Notes:
> - %{cf_id} &mdash; must be an ID of existing custom field
> - Be careful with code in formula, if it would wrong your application can be crashed

### Examples:

```Ruby
%{cf_1}*2+%{cf_2}
```

```Ruby
(%{cf_1}/3.14).round(2)
```

```Ruby
if %{cf_1}.zero?
 %{cf_2}/2
else
 %{cf_3}/2
end
```

Licensed under a [MIT-LICENSE](https://raw.githubusercontent.com/annikoff/redmine_plugin_computed_custom_field/master/MIT-LICENSE)