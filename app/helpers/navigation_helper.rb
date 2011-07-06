module NavigationHelper
  def section_is_dashboard?
    current_page? company_dashboard_path
  end

  def section_is_freights?
    controller_name == 'freights' && !section_is_my_freights?
  end
  
  def section_is_loading_spaces?
    controller_name == 'loading_spaces' && !section_is_my_loading_spaces?
  end
  
  def section_is_my_freights?
    controller_name == 'freights' && @company == current_company
  end

  def section_is_my_loading_spaces?
    controller_name == 'loading_spaces' && @company == current_company
  end

  def section_is_companies?
    %w(companies).include?(controller_name) && @company != current_company
  end

  def section_is_settings?
    %w(users).include?(controller_name) || (controller?(:companies) && action_name == 'edit')
  end

  def section_is_stations?
    %w(stations).include?(controller_name)
  end
end