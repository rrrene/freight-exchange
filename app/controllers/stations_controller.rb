class StationsController < ApplicationController
  autocomplete :station, :searchable, :extra_data => [:numeric_id, :name], :display_value => :full_name, :full => true
end
