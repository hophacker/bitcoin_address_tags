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
    class PriceCrawler
# For btcextw, you need the coockie to get transaction information
# The cookie string can be found by press <F12> in Chrome
# Maitainer: Jie Feng, jiefeng.hopkins@gmail.com
      def initialize(cookie)
        @@cookie = cookie
      end

      def mai_open(url)
        return Nokogiri::HTML(open(url))
        rescue 
          return nil
      end

      def get_transactions_btcextw
        url = "https://www.btcextw.com/RT_transaction.aspx"
        doc = Nokogiri.HTML(open(url, "Cookie" => @@cookie["btcextw"]))
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
        return  {'sell' => sell_prices, 'buy' => buy_prices}
      end


      def get_price_btcextw
        doc = mai_open("https://www.btcextw.com/login.aspx")
        if doc == nil
        else
          value = doc.css('#top > table >  tr > td #ctl00_Label17').text
          return {'Price'=>value, 'Transactions' => get_transactions_btcextw}
        end
      end
      def get_price_bitcoin_tw
        doc = mai_open("http://www.bitcoin-tw.com/")
        if doc == nil
          return {}
        else
          p doc.css("#btc-bid-field")
          return {'Bid' => doc.css("#btc-bid-field").text, 
                  'Ask' => doc.css("#btc-ask-field").text}
        end
      end
      def get_price_bitquick
        doc = mai_open("https://www.bitquick.tw/")
        if doc == nil
          return {}
        else
          str = doc.css("#post-3032 > div:nth-child(1) > div > div > div > div > h2:nth-child(2)").text
          price = str.gsub!(/[\D]*/, "")
          return {'Bitstamp' => price}
        end
      end

      def get_price_bitoex
        doc = Nokogiri::HTML(open("https://bitoex.com/", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
        return {'Price' => doc.css("#wrap > div.index_row > div > a > span.dny_rate").text}
      end

      def get_price_bitage
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
        return prices
      end
      
      def get_price_terarows

        doc = mai_open("http://bitcoin.terarows.com/")
        if doc == nil
          return {}
        else
          return {'Last Dealt Price' => doc.css("#LastPrice").text}
        end
      end

      def get_prices
        return {
          #'bitcoin-tw' => get_price_bitcoin_tw,
          'bitquick' => get_price_bitquick,
          'bitage' => get_price_bitage,
          'btcextw' => get_price_btcextw,
          'bitoex' => get_price_bitoex,
          'bitcoin_terarows' => get_price_terarows
        }
      end
      def show
        tw_prices = get_prices
        PP::pp tw_prices
      end
    end
  end
end



Ticker::Sources::PriceCrawler.new({"btcextw" => "ASP.NET_SessionId=uv2ryjgwcjkazuiiordr5uwa; _ga=GA1.2.1471105860.1405710858"}).show

#tw_prices.each do |name, price|
#printf("%-10s:\tPrice:%-15s Bid:%-15s Ask:%-20s\n", name, price['Price'], price['Bid'], price['Ask'])
#end

