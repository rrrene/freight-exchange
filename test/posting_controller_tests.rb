
module ::PostingControllerTests
  include ::RemoteControllerTests

  def test_should_get_index_with_filters
    [
      {:company_id => 1},
      {:origin_station_id => 1},
      {:destination_station_id => 2},
      {:origin_city => "Bochum"},
      {:destination_city => "Essen"},
    ].each do |parameters|
      puts ""
      puts "testing #{parameters.inspect}"
      puts ""
      assert_login_required_for :index, parameters
    end
  end

end
