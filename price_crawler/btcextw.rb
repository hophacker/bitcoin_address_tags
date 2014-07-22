# For btcextw, you need the coockie to get transaction information
# The cookie string can be found by press <F12> in Chrome
# Maitainer: Jie Feng, jiefeng.hopkins@gmail.com
module Ticker
  module Sources
    class Btcextw < HtmlBase

      def id
        "btcextw"
      end

      def fetch_transactions
        return {} if @cookie == nil
        url = "https://www.btcextw.com/RT_transaction.aspx"
        doc = Nokogiri.HTML(open(url, "Cookie" => @cookie))
        prices_doc = doc.css("#ctl00_ContentPlaceHolder1_Label17")

        buy_prices_doc = prices_doc.css("div:nth-child(1) tr")
        sell_prices_doc = prices_doc.css("div:nth-child(2) tr")


        buy_prices = []
        first = true
        buy_prices_doc.each do |buy_price_doc|
          if first
            first = false
          else
            buy_prices.push({
              "price" => buy_price_doc.css("td:nth-child(1)").text,
              "amount" => buy_price_doc.css("td:nth-child(2)").text,
              "total" => buy_price_doc.css("td:nth-child(3)").text,
            })
          end
        end

        sell_prices = []
        first = true
        sell_prices_doc.each do |sell_price_doc|
          if first
            first = false
          else
            sell_prices.push({
              "price" => sell_price_doc.css("td:nth-child(1)").text,
              "amount" => sell_price_doc.css("td:nth-child(2)").text,
              "total" => sell_price_doc.css("td:nth-child(3)").text,
            })
          end
        end
        {'sell' => sell_prices, 'buy' => buy_prices}
      end
      def fetch
        doc = mai_open("https://www.btcextw.com/login.aspx")
        if doc == nil
        else
          value = doc.css('#top > table >  tr > td #ctl00_Label17').text
          return {'Price'=>value, 'Transactions' => fetch_transactions}
        end
      end
    end
  end
end
#puts Ticker::Sources::Btcextw.new.fetch
#puts Ticker::Sources::Btcextw.new("ASP.NET_SessionId=zukwomuyk4ksgzv0fxgruayc; _ga=GA1.2.536985112.1405644308").fetch
