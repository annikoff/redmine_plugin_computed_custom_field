### ComputedCustomField plugin for Redmine

### Description:
This plugin adds new type of Custom Field named "computed".
Value of computed field can be set by formula.
In formula constructions like %{cf_id} are replaced by IDs of custom fields.
Valid formula is a valid Ruby code executed when customized object is updated.

![ComputedCustomField plugin for Redmine](https://raw.githubusercontent.com/annikoff/images/master/redmine_plugin_computed_custom_field.png "")


> ### Notes:
> - %{cf_id} &mdash; must be an ID of existing custom field
> - Be careful with code in formula, if it would wrong your application can be crashed
> - This plugin has been tested on Redmine v3.1 with RoR v4.2.3, and doesn't work on Redmine v2.x

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

Licensed under the [MIT-LICENSE](https://raw.githubusercontent.com/annikoff/redmine_plugin_computed_custom_field/master/MIT-LICENSE)