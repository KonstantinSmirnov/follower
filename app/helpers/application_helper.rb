module ApplicationHelper
  def page_primary_class(path)
    case path
    when root_path
      return 'landing-page'
    when landing_path
      return 'landing-page'
    else
      return 'follower-page'
    end
  end

  def controller?(*controller)
    controller.include?(params[:controller])
  end
  
  def action?(*action)
    action.include?(params[:action])
  end

  def namespace?(*namespace)
    namespace.include?(params[:controller].split('/').first)
  end

end
