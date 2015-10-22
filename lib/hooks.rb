module ComputedCustomField
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_layouts_base_html_head, :partial => 'hooks/base_head'
  end
end
