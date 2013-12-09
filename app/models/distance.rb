require 'net/http'

class Distance < ActiveRecord::Base
  cattr_accessor :status

  TIME = 1

  def self.distance(from, to)
    return rand(10**5) if Rails.env.test?
    from.gsub!(/\s+/,' ')
    to.gsub!(/\s+/,' ')
    from_to = [CGI::escape(from),CGI::escape(to)]
    time = 0.5
    ret = 0
    while(time <= TIME*3)
      begin
        Net::HTTP.start('maps.googleapis.com') do |http|
          http.read_timeout = time
          url = "/maps/api/directions/json?origin=%s&destination=%s&region=us&sensor=false"%from_to
          Rails.logger.info("-->Request URL: http://maps.googleapis.com" + url)
          response = http.get(url)
          json = JSON.parse(response.body)
          Distance.status = json["status"]
          if json["status"]=="OK"
            ret = json["routes"][0]["legs"][0]["distance"]["value"].to_i
            Rails.logger.info(">>>>> Response Distance: #{ret}" )
            return ret
          else
            Rails.logger.info("---<<" + json.to_s)
          end
          sleep(time*2)
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

