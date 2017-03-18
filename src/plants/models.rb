require 'sequel'

##
# Base class for a plant
#
class Plant < Sequel::Model
  one_to_many :hourly_temperature
  one_to_many :hourly_moisture
  one_to_many :hourly_light

  def to_json(*args)
    to_hash.to_json(*args)
  end
end


class HourlyTemperature < Sequel::Model(:temperature_hourly)
  many_to_one :plant

  def to_json(*args)
    to_hash.to_json(*args)
  end
end


class HourlyMoisture < Sequel::Model(:moisture_hourly)
  many_to_one :plant

  def to_json(*args)
    to_hash.to_json(*args)
  end
end


class HourlyLight < Sequel::Model(:light_hourly)
  many_to_one :plant

  def to_json(*args)
    to_hash.to_json(*args)
  end
end
