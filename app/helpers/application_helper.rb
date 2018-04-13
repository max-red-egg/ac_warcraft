module ApplicationHelper
  def active_class?(current_path)
    return 'active' if request.path == current_path
  end

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def to_markdown(text)
    html_render_options = {
      filter_html:     true, # no input tag or textarea
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow' },
      no_images:       true
    }

    markdown_options = {
      autolink:           true,
      fenced_code_blocks: true,
      lax_spacing:        true,
      no_intra_emphasis:  true,
      strikethrough:      true,
      superscript:        true
    }

    renderer = Html.new(html_render_options)
    markdown = Redcarpet::Markdown.new(renderer, markdown_options)
    raw markdown.render(text)
  end
end
