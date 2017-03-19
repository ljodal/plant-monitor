
##
# Route to get a list of all plants
#
get '/api/plants' do
  content_type :json

  Plant.all.to_json
end

##
# Route to create a new plant
#
put '/api/plants' do
  content_type :json

  data = JSON.parse(request.body.read)
  name = data['name']
  if not name
    halt 400, {
      error: true,
      message: 'Name must be specified'
    }.to_json
  end

  status 201
  Plant.create(name: name).to_json
end


##
# Route to get a specific plant
#
get '/api/plants/:id' do |id|
  content_type :json

  plant = Plant[id]
  if plant
    plant.to_json
  else
    halt 404, {
      error: true,
      message: 'No such plant',
    }.to_json
  end
end


##
# Route to get temperature readings for a plant
#
get '/api/plants/:id/temperature' do |id|
  content_type :json

  plant = Plant[id]
  if plant
    Plant[id].hourly_temperature.to_json
  else
    halt 404, {
      error: true,
      message: 'No such plant',
    }.to_json
  end
end


##
# Route to get moisture readings for a plant
#
get '/api/plants/:id/temperature' do |id|
  content_type :json

  plant = Plant[id]
  if plant
    Plant[id].hourly_moisture.to_json
  else
    halt 404, {
      error: true,
      message: 'No such plant',
    }.to_json
  end
end
