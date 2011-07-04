module NavigationHelper
  def section_is_dashboard?
    current_page? company_dashboard_path
  end

  def section_is_freights?
    %w(freights).include?(controller_name)
  end
  
  def section_is_loading_spaces?
    %w(loading_spaces).include?(controller_name)
  end

  def section_is_companies?
    %w(companies).include?(controller_name) && @company != current_company
  end

  def section_is_settings?
    %w(users).include?(controller_name) || (controller?(:companies) && action_name == 'edit')
  end
end