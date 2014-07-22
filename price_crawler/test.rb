require './base'
require './html_base'
require './bitquick'
require './bitage'
require './btcextw'
require './bitoex'
require './terarows'
require './coinbase'


module Ticker
  module Sources
    class Test
      def show
        #coinbase = CoinBase.new.fetch
        res =  {
          #'bitcoin-tw' => get_price_bitcoin_tw,
          'bitquick' => Bitquick.new.fetch,
          'bitage' => Bitage.new.fetch,
          'btcextw' => Btcextw.new.fetch,
          'bitoex' => Bitoex.new.fetch,
          'terarows' => Terarows.new.fetch,
          #'coinbase' => CoinBase.new.extract(coinbase)
        }
        PP::pp res
      end
    end
  end
end


Ticker::Sources::Test.new.show
