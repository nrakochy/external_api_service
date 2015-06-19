require 'uri'

class URI_Builder

  def self.build_uri(url, queries = {})
    endpoint = URI(url)
    endpoint.query = URI.encode_www_form(queries) if !queries.empty?
    endpoint
  end

end

