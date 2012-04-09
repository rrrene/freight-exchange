
module ::PostingControllerTests
  include ::RemoteControllerTests

  def test_should_get_index_with_filters_company_id
    assert_login_required_for :index, {:company_id => "1"}
  end

  def test_should_get_index_with_filters_origin_station_id
    assert_login_required_for :index, {:origin_station_id => "1"}
  end

  def test_should_get_index_with_filters_destination_station_id
    assert_login_required_for :index, {:destination_station_id => "2"}
  end

  def test_should_get_index_with_filters_origin_city
    assert_login_required_for :index, {:origin_city => "Bochum"}
  end

  def test_should_get_index_with_filters_destination_city
    assert_login_required_for :index, {:destination_city => "Essen"}
  end

end
