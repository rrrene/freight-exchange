class FreightsController < InheritedResources::Base
  login_required
  same_company_required :only => %w(edit update)
  ownership_required :only => %w(edit update)
  
  def new
    @freight = Freight.new
    @freight.build_origin_site_info(:date => Time.new)
    @freight.build_destination_site_info(:date => Time.new)
  end
end
