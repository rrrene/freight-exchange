module NavigationHelper
  def section_is_dashboard?
    current_page? company_dashboard_path
  end

  def section_is_postings?
    %w(freights loading_spaces).include?(controller_name)
  end

  def section_is_companies?
    %w(companies).include?(controller_name) && @company != current_company
  end
end