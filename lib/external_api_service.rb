require 'external_api_service/http_client'
require 'external_api_service/https_client'
require 'external_api_service/uri_builder'

module ExternalApiService

  # Make a GET request to external endpoint
  # @param url is required
  # @param query is optional. Query must be formatted as Ruby hash.
  #
  # @return Will transform the JSON to Ruby Hash with symbolized names
  #
  # @example
  # ExternalApiService.get_service("sample_endpoint", {sample_hash: "sample_request"})

  def self.get_service(url, queries = nil)
    uri = URI_Builder.new.build_uri(url, queries)
    uri.scheme.include?("https") ? HTTPS_Client.new.get(uri) : HTTP_Client.new.get(uri)
  end

end
