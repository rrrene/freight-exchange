module FreightsHelper
  def matching_results
    @matching_results ||= resource.matching_loading_spaces
  end
end
