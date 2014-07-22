require './html_base'
module Ticker
  module Sources
    class Terarows < HtmlBase

      def id
        "terarows"
      end
      def fetch
        doc = mai_open("http://bitcoin.terarows.com/")
        if doc == nil
          return {}
        else
          return {'Last Dealt Price' => doc.css("#LastPrice").text}
        end
      end
    end
  end
end

#puts Ticker::Sources::Terarows.new.fetch
