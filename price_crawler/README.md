Price Crawler
===========
# List of competitors:
* https://www.bitquick.tw/
* http://www.bitcoin-tw.com/
* https://www.btcextw.com/index.aspx
* https://bitoex.com/
* http://www.bitage.tw
* http://bitcoin.terarows.com
* https://coinbase.com/


# Introduction

There are two types of "Price Cralwer":
* One type is to call existed API, which normally returns json data. For this type of crawler, it is enough to make a *http request*.
* The other type is to extract information from html page. For this type, there are several issues related to it.
    * A ruby gem which can extract information from raw html page would be pretty helpful, the one we use here is "nokogiri", which can directly extract information from html page using css path. Then you can navigate the dom element of html just like using jQuery's selector.

    * Prices of Bitcoin-tw is shown dynamicly by using javascript, thus the price can't be grabbed just by requesting the page. We need either:
        * Use some technique to render javascripts for that page locally.
        * Or find the URI which the page uses to access the data. I've checked, this website get the prices from this address: **wss://s-dal5-nss-23.firebaseio.com/.ws?v=5&ns=publicdata-cryptocurrency** , which uses web secure socket, which is involved private key and crypto stuff.
     
        This part hasn't been done perfectly.
    * In order to visit btcextw's trading center, you need to log in and get the cookie session. But the login part has image recognition and is hard to crack. So I made a deamon program which will refresh the cookie session in 30 seconds, that's why you can see the transaction records in http://hey.i-feng.org:3331/price/index . But it's only for temporary usage, I have no idea of long-term method yet.
    This part hasn't done perfectly either.
    * Some pages can shutdown sometimes, so I added a function called *mai_open* to solve that.
    * Some websites we are crawling do not have SSL certificate, we need to use the following piece of code to circumvent that issue.
```ruby
doc = Nokogiri::HTML(open("https://bitoex.com/", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
```



 

# Classes
**Base** is the base class of all price cralwlers.

**CoinBaes** inherits *Base* since crawling *CoinBase* is directly API call.

**HtmlBase** inherits *Base*, and it's the base class of all crawlers which will crawl prices from raw html page. Adding this class is because
    * The crawlers which crawl prices from html page behave differently are have more issues and exceptions to deal with, we need to seperate them from the ones which just call existed APIs.
    * *Base* class is written by someone else and change the code is not good, so I made a new one and provide convenient functionalities in the new class instead.

**BitcoinTw Bitquick Bitage  Bitoex Btcextw Terarows** all crawlers crawling information from html pages, and they are all inherited from *HTMLBase*

**Test** is a seperate class which is used to test the price crawlers.

# Maintainer
Jie Feng: jie@maicoin.com