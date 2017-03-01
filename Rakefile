require 'sequel/rake'

Sequel::Rake.load!
Sequel::Rake.configure do
  set :connection, {
    adapter: 'postgres',
    dbname: ENV.fetch('DB_NAME', 'pipeline'),
    user: ENV.fetch('DB_USER', 'pipeline'),
    host: ENV.fetch('DB_HOST', 'localhost'),
    port: ENV.fetch('DB_PORT', 5432),
    password: ENV.fetch('DB_PASS', 'pipeline'),
  }
end
