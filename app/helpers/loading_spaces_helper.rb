module LoadingSpacesHelper
  def matching_results
    @matching_results ||= resource.matching_objects
  end
end
