require "rubygems"
require "time"
require "httpclient"

module Ticker
  module Sources
    class Base

      def id
        "source id"
      end

      def get_data
        raw = fetch
        if validate(raw)
          extract(raw)
        else
          nil
        end
      end

      def update_interval
        1
      end

      def fetch
        nil
      end

      def validate(raw)
        return nil unless raw
        true
      end

      def extract(raw)
        {
          :remote_ts => Time.now.to_f,
          :local_ts => Time.now.to_f,
          :price_bid1 => 0.0,
          :price_ask1 => 0.0,
          :price_last => 0.0,
          :currency => 'USD'
        }
      end
 
      def http_get(addr)
        puts "HTTP GET: #{addr}"
        begin
          return HTTPClient.get_content(addr)
        rescue Exception => ex
          puts ex
          return nil
        end
      end

    end
  end
end


