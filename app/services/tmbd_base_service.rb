require 'uri'
require 'net/http'
class TmbdBaseService
  def self.api_cal(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = "Bearer #{ENV['TMBD_ACCESS_TOKEN']}"

    response = http.request(request)
    response.read_body
  end
end
