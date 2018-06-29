module AttributeQuickiesContextMenu
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_context_menu_start, :partial => 'hooks/attribute_quickies/context_menu_head'
  end
end

