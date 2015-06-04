require 'external_api_service/http_client'
require 'external_api_service/https_client'
require 'external_api_service/uri_builder'

module ExternalApiService

  def self.get_service(url, queries = nil)
    uri = URI_Builder.new.build_uri(url, queries)
    uri.scheme.include?("https") ? HTTPS_Client.new.get(uri) : HTTP_Client.new.get(uri)
  end

end
