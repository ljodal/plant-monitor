require 'sequel/rake'

Sequel::Rake.load!
Sequel::Rake.configure do
  set :connection, {
    adapter: 'postgres',
    dbname: 'pipeline',
    user: 'pipeline',
    host: 'localhost',
    port: 5432,
    password: 'pipeline'
  }
end
