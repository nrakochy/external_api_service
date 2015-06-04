require 'external_api_service/http_client'
require 'external_api_service/https_client'
require 'external_api_service/uri_builder'
require 'external_api_service/version'

class ExternalApiService

  def self.get_service(url, queries = nil)
    uri = URI_Builder.build_uri(url, queries)
    url.include?("https") ? HTTPS_Client.get(uri) : HTTP_Client.get(uri)
  end

end
