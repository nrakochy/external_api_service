require 'net/http'
require 'json'

class HTTP_Client

  def get(endpoint_uri)
    response = get_request(endpoint_uri)
    parse_response(response)
  end

  def post
  end

  def get_request(endpoint)
    check_ssl = endpoint.scheme == "https"
    Net::HTTP.start(endpoint.host, endpoint.port, :use_ssl => check_ssl) do |client|
      retries = 5
      begin
        new_request = Net::HTTP::Get.new(endpoint)
        client.request(new_request)
      rescue Exception => ex
        retries -= 1
        retries > 0 ? retry : error_response(422, ex)
      end
    end
  end

  def parse_response(response)
    if (response.code != "200" || response.code == nil)
      { error: response }
    else
      JSON.parse(response.body, symbolize_names: true)
    end
  end

  private

  def error_response(err_code, exception)
    error = Struct.new(:code, :exception)
    error.new(err_code, exception)
  end
end

