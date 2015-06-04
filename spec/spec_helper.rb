require 'coveralls'
require 'webmock/rspec'

$LOAD_PATH.unshift File.expand_path('../../lib/external_api_service/', __FILE__)

require 'external_api_service'
require 'http_client'
require 'https_client'
require 'uri_builder'


Coveralls.wear!
WebMock.disable_net_connect!(allow_localhost: true)

