require_relative './models'

# Only load the API endpoint if Sintra has been required
# first. This way we don't have to require sintra when
# starting a shell
require_relative './api' if defined? Sinatra
