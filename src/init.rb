require 'sequel'

# Connect to the database
db_config = {
  adapter:  'postgres',
  dbname:   ENV.fetch('DB_NAME', 'pipeline'),
  user:     ENV.fetch('DB_USER', 'pipeline'),
  host:     ENV.fetch('DB_HOST', 'localhost'),
  port:     ENV.fetch('DB_PORT', 5432),
  password: ENV.fetch('DB_PASS', 'pipeline'),
}
DB = Sequel.connect(db_config)

# Require other files
require_relative './auth/init'
require_relative './plants/init'
