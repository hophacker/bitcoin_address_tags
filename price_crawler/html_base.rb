require 'nokogiri'
require 'openssl'
require 'socket'
require 'open-uri'
require 'thread'
require 'set'
require 'openssl'
require 'pp'

module Ticker
  module Sources
    class HtmlBase < Base

      def initialize(cookie = nil)
        @cookie = cookie
      end

      def id
        "HtmlBase"
      end

      def mai_open(url)
        return Nokogiri::HTML(open(url))
        rescue 
          return nil
      end
    end
  end
end


