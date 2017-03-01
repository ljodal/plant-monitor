# Plant monitor

A web based API to collect and aggregate metrics from plants


## Requirements

 * Ruby >= 2.0.0
 * Docker


## How to run

### Install dependencies

```shell
gem install bundler
bundle install
```

### Start the database

```shell
docker run -p 0.0.0.0:5432:5432 --rm pipelinedb/pipelinedb
```

### Run migrations

```shell
bundle exec rake sequel:migrate
```

### Start the server application

```shell
bundle exec ruby server.rb
```


## How to use

To add some data, `PUT` against `/api/metrics`. This accepts json like this:

```json
[
    {
        "id": 1,
        "type": "temp",
        "value": 20
    },
    {
        "id": 1,
        "type": "moisture",
        "value": 200
    }
]
```

If you save this JSON to a file called `metrics.json`, you can submit these metrics using curl:

```shell
curl -X PUT -u admin:secret -d @- http://localhost:4567/api/metrics < metrics.json
```

and retrieve the result using curl

```shell
curl -u admin:secret http://localhost:4567/api/temperature/1
```


## TODO

 * `docker-compose` setup
 * Configurable username/password
 * Frontend
