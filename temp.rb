require 'nokogiri'
require 'openssl'
require 'socket'
require 'open-uri'
require 'thread'
require 'set'
require './MaiWriter.rb'
require 'openssl'
require 'pp'

url = "https://www.btcextw.com/RT_transaction.aspx"
Cookie = "ASP.NET_SessionId=uv2ryjgwcjkazuiiordr5uwa; _ga=GA1.2.1471105860.1405710858"
doc = Nokogiri.HTML(open(url, "Cookie" => Cookie))
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


prices = {'new_transactions' => {
  'sell' => sell_prices,
  'buy' => buy_prices
}}


PP::pp prices

