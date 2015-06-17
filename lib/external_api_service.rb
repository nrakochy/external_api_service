require 'external_api_service/http_client'
require 'external_api_service/uri_builder'

module ExternalApiService

  # Make a GET request to external endpoint
  # @param url is required
  # @param query is optional. Query must be formatted as Ruby hash.
  # @param auth is optional but probably required by the service you are hitting. You must format it as an array ["username", "password"]
  #
  # @return Will transform the JSON to Ruby Hash with symbolized names
  #
  # @example
  # ExternalApiService.get_service("sample_endpoint", {sample_hash: "sample_request"})

  def self.get_service(url, queries = {}, auth = [])
    uri = URI_Builder.build_uri(url, queries)
    HTTP_Client.new.get(uri, auth)
  end

  # Make a POST request to external endpoint
  # @param url is required
  # @param data is required
  # @param auth is optional but probably required by the service you are hitting. You must format it as an array ["username", "password"]
  #
  # @return Will transform the JSON to Ruby Hash with symbolized names
  #
  # @example
  # auth = ["username", "password"]
  # ExternalApiService.post_service("sample_endpoint", sample_data: "sample_request"}, auth)

  def self.post_service(url, data)
    HTTP_Client.new.post(url, data)
  end

end
