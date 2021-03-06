require 'sinatra'
require 'json'

# Require plant stuff
require_relative './src/init.rb'


# Variable to keep track of whether we have already
# prepared the insert statements or not
$has_prepared = false

##
# Prepare our insert statements
#
def prepare
  # Only do this once
  return if $has_prepared

  prepared_statements = {
    temperature_readings: :insert_temp,
    moisture_readings: :insert_moisture,
    light_readings: :insert_light,
  }

  prepared_statements.each do |table, name|
    DB[table].prepare(:insert, name, plant_id: :$plant_id, value: :$value)
  end

  $has_prepared = true
end


##
# Use basic auth through rack for authentication
#
use Rack::Auth::Basic do |username, password|
  user = User.where(email: username).first
  user && user.verify_password(password)
end

##
# Helper method execute the prepared statements
#
def insert(objects)
  # Make sure the prepared statements are ready
  prepare unless $has_prepared

  objects.map do |o|
    params = {
      plant_id: o['id'],
      value: o['value'],
    }
    case o['type']
    when 'temp'
      DB.call(:insert_temp, params)
    when 'moisture'
      DB.call(:insert_moisture, params)
    when 'light'
      DB.call(:insert_light, params)
    else
      {
        error: "Unknown metric type: #{o['type']}",
        params: params,
      }
    end
  end
end


##
# Submit metrics for one or more sensors
#
put '/api/metrics' do
  data = JSON.parse(request.body.read)

  # Check that we got an array of metrics
  unless data.is_a? Array
    status 400
    content_type :json
    return {
      error: true,
      message: 'Body must be an array',
    }.to_json
  end

  # Validate each metric
  content_type :json
  return {
    sql: insert(data),
    count: data.length,
  }.to_json
end
