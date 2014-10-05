module Ticker
  module Sources
    class CoinBase < Base

      def id
        "coinbase"
      end

      def fetch
        uri_buy = "https://coinbase.com/api/v1/prices/buy"
        uri_sell = "https://coinbase.com/api/v1/prices/sell"

        response_buy = http_get(uri_buy)
        response_sell = http_get(uri_sell)

        return nil unless response_buy && response_sell

        [response_buy, response_sell].join("\n")
      end

      def update_interval
        # we don't know about coinbase's actual access limits. 10s is a fair guess
        20.0
      end

      def validate(raw)
        # sample raw:
        # {"subtotal":{"amount":"789.50","currency":"USD"},
        #  "fees":[{"coinbase":{"amount":"7.90","currency":"USD"}},{"bank":{"amount":"0.15","currency":"USD"}}],
        #  "total":{"amount":"797.55","currency":"USD"},
        #  "amount":"797.55",
        #  "currency":"USD"}
        # {"subtotal":{"amount":"789.90","currency":"USD"},
        #  "fees":[{"coinbase":{"amount":"7.90","currency":"USD"}},{"bank":{"amount":"0.15","currency":"USD"}}],
        #  "total":{"amount":"781.85","currency":"USD"},
        #  "amount":"781.85",
        #  "currency":"USD"}
        return nil unless raw
        raw.include?('subtotal') && raw.include?('total') && raw.include?("\n")
      end

      def extract(raw)
        ts = Time.now.to_f
        raw_buy, raw_sell = raw.split("\n")
        data_buy = JSON.load(raw_buy)
        data_sell = JSON.load(raw_sell)
        {
          :remote_ts => 0.0, # missing
          :local_ts => ts,
          :price_bid1 => data_sell['amount'].to_f,
          :price_ask1 => data_buy['amount'].to_f,
          :price_last => (data_sell['amount'].to_f + data_buy['amount'].to_f) / 2,
          :currency => data_sell['currency'].upcase,
        }
      end

    end
  end
end
