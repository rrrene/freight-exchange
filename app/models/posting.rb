class Posting < ActiveRecord::Base
  belongs_to :user
  belongs_to :origin_station, :class_name => 'Station'
  belongs_to :destination_station, :class_name => 'Station'
  
  def to_search
    "
    [#{type}]
      #{origin_station.to_search} -> #{destination_station.to_search}
      #{origin_date.to_s} -> #{destination_date.to_s}
    [#{goods_type}]
      #{wagon_type}
      #{loading_meter}
      #{weight}
    ".simplify
  end
  
  def validate
    if origin_station_id == destination_station_id
      errors.add :destination_station_id, 'Stations must be different'
    end
    if origin_date > destination_date
      errors.add :destination_date, 'Destination cannot be before loading'
    end
  end
  
  validates_presence_of :type
  validates_presence_of :user_id
  validates_presence_of :origin_station_id
  validates_presence_of :destination_station_id
  validates_presence_of :origin_date
  validates_presence_of :destination_date
  validates_presence_of :goods_type
  validates_presence_of :wagon_type
  validates_presence_of :loading_meter
  validates_presence_of :weight
end
