require 'coveralls'
Coveralls.wear!

require 'webmock/rspec'

$LOAD_PATH.unshift File.expand_path('../../lib/', __FILE__)

require 'external_api_service.rb'
require 'external_api_service/http_client'
require 'external_api_service/https_client'
require 'external_api_service/uri_builder'

WebMock.disable_net_connect!(allow_localhost: true)

