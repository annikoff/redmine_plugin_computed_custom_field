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
> - If format of Custom Field is Text, Long Text or List, you need to surround '%{cf_id}' with quotes
> - Be careful with code in formula, if it would wrong your application can be crashed
> - This plugin has been tested on Redmine v2.6.7 with RoR v3.2.22 and Redmine v3.1 with RoR v4.2.3
> - There are six types of output format: "int", "float", "string", "link", "datetime", "bool", "percentage"
> - If a computed custom field was created after creating of customized object you need to re-save an object to evaluate computations
> - After updating of formula customized objects should be re-saved

### Installation:

Clone from GitHub
```sh
git clone https://github.com/annikoff/redmine_plugin_computed_custom_field.git computed_custom_field
```

Or download [ZIP-archive](https://github.com/annikoff/redmine_plugin_computed_custom_field/archive/master.zip) and extract it into "computed_custom_field" directory.

### Examples:
```ruby
%{cf_1}*2+%{cf_2} 
# means 
# custom_field_value(1) * 2 + custom_field_value(2)
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

```ruby
# If format of Custom Field with ID 4 is Text, Long Text or List
'%{cf_4}'
```

```ruby
# If format of Custom Field is Link
"/projects/#{self.project_id.to_s}/issues/new?issue[subject]=Review+request+[##{self.id.to_s} #{self.subject}]&issue[tracker_id]=3"
```

```ruby
# If format of Custom Field is Link, and you need to set up a specific link caption
"'Click here for more details':/projects/#{project.try(:identifier)}/wiki"
```

To write formulas this documentation can be helpful:
- [Issue](http://www.rubydoc.info/github/edavis10/redmine/Issue)
- [Project](http://www.rubydoc.info/github/edavis10/redmine/Project)
- [User](http://www.rubydoc.info/github/edavis10/redmine/User)
- [TimeEntry](http://www.rubydoc.info/github/edavis10/redmine/TimeEntry)
- [Version](http://www.rubydoc.info/github/edavis10/redmine/Version)
- [Group](http://www.rubydoc.info/github/edavis10/redmine/Group)
- [Document](http://www.rubydoc.info/github/edavis10/redmine/Document)
- [TimeEntryActivity, IssuePriority, DocumentCategory](http://www.rubydoc.info/github/edavis10/redmine/Enumeration)

Licensed under the [MIT-LICENSE](https://raw.githubusercontent.com/annikoff/redmine_plugin_computed_custom_field/master/MIT-LICENSE)