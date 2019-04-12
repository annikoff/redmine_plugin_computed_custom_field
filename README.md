# This project is no longer maintained

## ComputedCustomField plugin for Redmine

[![Build Status](https://travis-ci.org/annikoff/redmine_plugin_computed_custom_field.svg?branch=master)](https://travis-ci.org/annikoff/redmine_plugin_computed_custom_field)
[![Code Climate](https://codeclimate.com/github/annikoff/redmine_plugin_computed_custom_field/badges/gpa.svg)](https://codeclimate.com/github/annikoff/redmine_plugin_computed_custom_field)

### Description:

This plugin provides a possibility to create a computed custom field.
The value of the computed field can be set by formula.
In formula constructions like `cfs[cf_id]` are replaced by IDs of custom fields.
A valid formula is a valid Ruby code executed when a customized object is updated.
To put a field ID in the formula, double-click on an item in the list of available fields.


![ComputedCustomField plugin for Redmine](https://raw.githubusercontent.com/annikoff/images/master/redmine_plugin_computed_custom_field_v_1_0_3.png)

### Changelog:

Plugin's changelog is available [here](CHANGELOG.md).

### Important information

This is a new version of the plugin. Since version 1.0.0 it is not compatible with previous versions.
The following constructions in formula `%{cf_id}` are no longer supported. Instead use `cfs[cf_id]`.
If you need to upgrade from older versions, please check out migration section.

> ### Notes:
> - cfs[cf_id] &mdash; must be an ID of existing custom field.
> - Be careful with code in a formula, if it would wrong your application can be crashed.
> - If a computed custom field was created after creating of a customized object you need to re-save an object to evaluate computations.
> - After updating of formula customized objects should be re-saved.

### Installation:

Clone from GitHub
```sh
# Latest version
git clone https://github.com/annikoff/redmine_plugin_computed_custom_field.git computed_custom_field
```

Or download [ZIP-archive](https://github.com/annikoff/redmine_plugin_computed_custom_field/archive/master.zip) and extract it into "computed_custom_field" directory.

Run migrations
```sh
rake redmine:plugins:migrate
```

### Migration:
- Navigate to plugin folder.
- Run `git pull`
- Run `rake redmine:plugins:migrate`
- In computed CF's formulas replace `%{cf_id}` constructions by `cfs[cf_id]`.

### Compatibility

The plugins supports the following Redmine versions: 4.0.x, 3.4.x, 3.3.x, 3.2.x, 3.1.x, 3.0.x, 2.6.x, 2.5.x.

### Examples:
```ruby
cfs[1]*2+cfs[2]
# means
# custom_field_value(1) * 2 + custom_field_value(2)
```

```ruby
(cfs[1]/3.14).round(2)
```

```ruby
if cfs[1].zero?
 cfs[2]/2
else
 cfs[3]/2
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
# If format of Custom Field is Link
"/projects/#{self.project_id.to_s}/issues/new?issue[subject]=Review+request+[##{self.id.to_s} #{self.subject}]&issue[tracker_id]=3"
```

```ruby
# Retrieve a value from Key/value list custom field
cfs[1].try(:id)
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


### Getting help

If you need help with a formula's code read [FAQ](https://github.com/annikoff/redmine_plugin_computed_custom_field/wiki/FAQ)
and check out [existing issues](https://github.com/annikoff/redmine_plugin_computed_custom_field/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3Aquestion+) 
or ask [Redmine community](https://www.redmine.org/projects/redmine/boards/2).

Licensed under the [MIT-LICENSE](MIT-LICENSE)
