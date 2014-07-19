require 'nokogiri'
require 'openssl'
require 'socket'
require 'open-uri'
require 'thread'
require 'set'
require './MaiWriter.rb'
require 'openssl'
require 'pp'

tw_prices = {}


def get_price_btcextw
  value = Nokogiri::HTML(open("https://www.btcextw.com/login.aspx")).css('#top > table >  tr > td #ctl00_Label17').text
  return {'Price'=>value}
end
def get_price_bitcoin_tw
  doc = Nokogiri::HTML(open("http://www.bitcoin-tw.com/"))
  p doc.css("#btc-bid-field")
  return {'Bid' => doc.css("#btc-bid-field").text, 
          'Ask' => doc.css("#btc-ask-field").text}
end
def get_price_bitquick
  doc = Nokogiri::HTML(open("https://www.bitquick.tw/"))
  str = doc.css("#post-3032 > div:nth-child(1) > div > div > div > div > h2:nth-child(2)").text
  price = str.gsub!(/[\D]*/, "")
  return {'Bitstamp' => price}
end

def get_price_bitage
  doc = Nokogiri::HTML(open("https://www.bitage.tw/", 
                            :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
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


client = server.accept       # Wait for a client to connect
tw_prices = {
  'btcextw' => get_price_btcextw,
  'bitcoin-tw' => get_price_bitcoin_tw,
  'bitquick' => get_price_bitquick,
  'bitage' => get_price_bitage
}
PP::pp tw_prices


#tw_prices.each do |name, price|
  #printf("%-10s:\tPrice:%-15s Bid:%-15s Ask:%-20s\n", name, price['Price'], price['Bid'], price['Ask'])
#end

