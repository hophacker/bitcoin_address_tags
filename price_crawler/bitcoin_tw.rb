require './html_base'
module Ticker
  module Sources
    class BitcoinTw < HtmlBase

      def id
        "btcextw"
      end

      def fetch
        doc = mai_open("http://www.bitcoin-tw.com/")
        if doc == nil
          {}
        else
          #p doc.css("#btc-bid-field")
          {'Bid' => doc.css("#btc-bid-field").text, 'Ask' => doc.css("#btc-ask-field").text}
        end
      end
    end
  end
end
puts Ticker::Sources::BitcoinTw.new.fetch
