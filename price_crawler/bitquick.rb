module Ticker
  module Sources
    class Bitquick < HtmlBase

      def id
        "bitquick"
      end
      def fetch
        doc = mai_open("https://www.bitquick.tw/")
        if doc == nil
          {}
        else
          str = doc.css("#post-3032 > div:nth-child(1) > div > div > div > div > h2:nth-child(2)").text
          price = str.gsub!(/[\D]*/, "")
          {'Bitstamp' => price}
        end
      end
    end
  end
end

#puts Ticker::Sources::Bitquick.new.fetch
