require 'net/http'

class Distance < ActiveRecord::Base
  cattr_accessor :status

  TIME = 1
  
  # PROXY = URI.parse(ENV['QUOTAGUARD_URL'])

  def self.distance(from, to)
    return rand(10**5) if Rails.env.test?
    from.gsub!(/\s+/,' ')
    to.gsub!(/\s+/,' ')
    from_to = [CGI::escape(from),CGI::escape(to)]
    time = 0.5
    ret = { }
    while(time <= TIME*3)
      begin
        Net::HTTP.start('maps.googleapis.com', 80) do |http|#, PROXY.host, PROXY.port, PROXY.user, PROXY.password) do |http|
          http.read_timeout = time
          url = "/maps/api/directions/json?origin=%s&destination=%s&region=us&sensor=false"%from_to
          Rails.logger.info("-->Request URL: http://maps.googleapis.com" + url)
          response = http.get(url)
          ret = JSON.parse(response.body)
          case ret["status"]
          when "OK"
            return { "status" => "OK", "distance" => ret["routes"][0]["legs"][0]["distance"]["value"].to_i }
          when "OVER_QUERY_LIMIT"
            Rails.logger.info("---<<" + ret.to_s)
            sleep(time * 2)
          else
            return ret
          end
        end
      rescue Exception=>ex
        Rails.logger.info(ex.message)
        sleep(time*2)
      end
      time+=0.5
    end
    ret
  end
end

