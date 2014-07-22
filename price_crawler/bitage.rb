require './html_base'
module Ticker
  module Sources
    class Bitage < HtmlBase

      def id
        "bitquick"
      end
      def fetch
        doc = Nokogiri::HTML(open("https://www.bitage.tw/", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
        prices = {}
        i = 0
        title=""
        doc.css('body > div.top_bar.hidden-xs.hidden-sm > div > div > div.col-md-8.col-md-offset-1 > ul > li').each do |e|
          if i % 2 == 1
            prices[title] = e.text
          else
            title = e.text
          end
          i+=1
        end
        prices
      end
    end
  end
end

#puts Ticker::Sources::Bitage.new.fetch
