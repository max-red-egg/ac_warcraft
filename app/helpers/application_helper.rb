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
end
