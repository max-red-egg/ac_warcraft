module ApplicationHelper
  def active_class?(current_path)
    return 'active' if request.path == current_path
  end
end
