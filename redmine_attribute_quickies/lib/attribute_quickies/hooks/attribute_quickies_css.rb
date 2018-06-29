module AttributeQuickiesCSS
  class Hooks < Redmine::Hook::ViewListener
	render_on :view_layouts_base_html_head, :partial => 'hooks/attribute_quickies/style_sheet'
  end
end

