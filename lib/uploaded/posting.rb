module Uploaded
  # This class converts values from the uploaded sheet to a format which the Freight and LoadingSpace class objects can parse.
  class Posting
    attr_accessor :attributes
    ATTRIBUTES = %w(origin_country origin_name origin_station_numeric_id destination_country destination_name destination_station_numeric_id) + 
      %w(valid_until product_name product_state hazmat hazmat_class un_no nhm_no desired_means_of_transport_custom) + 
        %w(total_weight frequency first_transport_at transport_weight own_means_of_transport_present desired_proposal_type)
  
    YES_NO_MAP = {
      %w(Ja Yes) => true, 
      %w(Nein No) => false
    }
    MAPS = {
      # %w(liquid gas loose packaged container)
      :product_state => {
        %w(Flüssig Liquid) => "liquid",
        %w(Gasförmig Gas) => "gas",
        %w(Lose Loose) => "loose",
        %w(Verpackt Packaged) => "packaged",
        %w(Container) => "container"
      },
      # %w(once weekly monthly yearly)
      :frequency => {
        %w(Einmalig Once) => "once",
        %w(Wöchentlich Weekly) => "weekly",
        %w(Monatlich Monthly) => "monthly",
        %w(Jährlich Yearly) => "yearly",
      },
      # %w(ton_price package_price unknown)
      :desired_proposal_type => {
        ["EUR pro Tonne", "€ pro Tonne", "€ / Tonne", 
         "EUR per ton", "€ per ton"] => "ton_price",
        ["EUR pro Wagen", "€ pro Wagen", "EUR per wagon", "€ per wagon"] => "package_price",
      },
      :own_means_of_transport_present => YES_NO_MAP,
      :hazmat => YES_NO_MAP,
    }
    
    ATTRIBUTES.each do |attr|
      define_method "#{attr}=" do |value|
        self.attributes[attr] = if self.respond_to?("#{attr}_map")
          map = self.__send__("#{attr}_map")
          map[value.to_s.strip] || value
        else
          value
        end
      end
    end
    
    MAPS.each do |map_key, map_hash|
      define_method "#{map_key}_map" do
        expand_map map_hash
      end
    end
    
    def initialize(row, headers)
      self.attributes = {}
      headers.each_with_index do |attr, i|
        self.__send__("#{attr}=", row[i])
      end
    end
    
    def nhm_no=(value)
      self.attributes["nhm_no"] = value.to_i.to_s
    end
    
    def un_no=(value)
      self.attributes["un_no"] = value.to_i.to_s
    end
    
    def destination_station_numeric_id=(value)
      attributes[:destination_station_id] = Station.where(:numeric_id => value).first.try(:id)
    end
    
    def origin_station_numeric_id=(value)
      attributes[:origin_station_id] = Station.where(:numeric_id => value).first.try(:id)
    end
    
    def expand_map(map, include_downcase = true)
      result = {}
      map.each do |arr, value|
        arr.each do |key|
          key = key.to_s.strip
          result[key] = value
          result[key.downcase] = value if include_downcase
        end
      end
      result
    end
  end
end