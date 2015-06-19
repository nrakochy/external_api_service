require 'external_api_service/http_client'
require 'external_api_service/uri_builder'

module ExternalApiService

  # Make a GET request to external endpoint
  # @param url is required
  # @param query is optional. Query must be formatted as Ruby hash.
  # @param auth is optional. If you choose to include it,
  # You must format it as a hash with string key/value {"username" => "password"}
  #
  # @return Will transform the JSON to Ruby Hash with symbolized names
  #
  # @example
  # ExternalApiService.get_service("sample_endpoint", {sample_search_query: "sample_request"})

  def self.get_service(url, queries = {}, credentials = {})
    credentials_formatted_for_auth = credentials.to_a.flatten
    uri = URI_Builder.build_uri(url, queries)
    HTTP_Client.new.get(uri, credentials_formatted_for_auth)
  end

  # Make a JSON POST request to external endpoint
  # @param url is required
  # @param data_to_post is required, since you are a making POST request after all.
  # @param auth is required, as it is not an idempotent action.
  # You must format it as a hash of strings (both key and value) e.g. {"username" => "password"}
  # @param header_params are optional. This sets content-type to "application/json", so do not include Content-Type.
  # You get several free headers with the Net/HTTP class, but it is there if you want it. Must be a hash
  #
  # @return Will transform the JSON to Ruby Hash with symbolized names
  #
  # @example
  # auth = {"api_key": "123key"}
  # data_to_post: {sample_data: "sample"}
  # ExternalApiService.post_service("sample_endpoint", data_to_post, auth)
  #
  # Note:
  # You have to have the trailing '/' for the path for Ruby to POST properly e.g. http://sample.com/

  def self.post_service(url, data_to_post, credentials, http_header_params = {})
    credentials_formatted_for_auth = credentials.to_a.flatten
    uri = URI_Builder.build_uri(url)
    http_params = { uri: uri, data: data_to_post, credentials: credentials_formatted_for_auth, header_params: http_header_params }
    HTTP_Client.new.post(http_params)
  end

end
