module Ticker
  module Sources
    class PriceCrawler < Base

      def get_prices
        return {
          #'bitcoin-tw' => get_price_bitcoin_tw,
          'bitquick' => get_price_bitquick,
          'bitage' => get_price_bitage,
          'btcextw' => get_price_btcextw,
          'bitoex' => get_price_bitoex,
          'terarows' => get_price_terarows
        }
      end
      def show
        tw_prices = get_prices
        PP::pp tw_prices
      end
    end
  end
end



#Ticker::Sources::PriceCrawler.new({"btcextw" => "ASP.NET_SessionId=uv2ryjgwcjkazuiiordr5uwa; _ga=GA1.2.1471105860.1405710858"}).show
#tw_prices.each do |name, price|
#printf("%-10s:\tPrice:%-15s Bid:%-15s Ask:%-20s\n", name, price['Price'], price['Bid'], price['Ask'])
#end

