module Ticker
  module Sources
    class Bitoex < HtmlBase

      def id
        "bitoex"
      end
      def fetch
        doc = Nokogiri::HTML(open("https://bitoex.com/", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
        {'Price' => doc.css("#wrap > div.index_row > div > a > span.dny_rate").text}
      end
    end
  end
end

#puts Ticker::Sources::Bitoex.new.fetch
