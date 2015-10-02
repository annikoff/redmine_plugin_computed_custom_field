### ComputedCustomField plugin for Redmine

### Description:
This plugin adds a new type of Custom Field named "computed".
The value of computed field can be set by formula.
In formula constructions like %{cf_id} are replaced by IDs of custom fields.
Valid formula is a valid Ruby code executed when customized object is updated.
To put a field ID in the formula, double-click on an item in the list of available fields.

![ComputedCustomField plugin for Redmine](https://raw.githubusercontent.com/annikoff/images/master/redmine_plugin_computed_custom_field.png "")

> ### Notes:
> - %{cf_id} &mdash; must be an ID of existing custom field
> - Be careful with code in formula, if it would wrong your application can be crashed
> - This plugin has been tested on Redmine v2.6.7 with RoR v3.2.22 and Redmine v3.1 with RoR v4.2.3
> - There are five types of output format: "int", "float", "string", "datetime", "bool"

### Installation:

Clone from GitHub
```sh
git clone https://github.com/annikoff/redmine_plugin_computed_custom_field.git computed_custom_field
```

Or download [ZIP-archive](https://github.com/annikoff/redmine_plugin_computed_custom_field/archive/master.zip) and extract it into "computed_custom_field" directory.

### Examples:

```ruby
%{cf_1}*2+%{cf_2}
```

```ruby
(%{cf_1}/3.14).round(2)
```

```ruby
if %{cf_1}.zero?
 %{cf_2}/2
else
 %{cf_3}/2
end
```

```ruby
# For IssueCustomField 
(self.estimated_hours || 0) * 2
```

```ruby
# For ProjectCustomField 
self.parent_id == 2
```

Licensed under the [MIT-LICENSE](https://raw.githubusercontent.com/annikoff/redmine_plugin_computed_custom_field/master/MIT-LICENSE)