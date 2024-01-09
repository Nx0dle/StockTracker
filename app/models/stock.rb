class Stock < ApplicationRecord
  require 'alphavantage'

  def self.new_lookup(ticker_symbol)
    Alphavantage.configure do |config|
      config.api_key = Rails.application.credentials.alphavantage[:api_key]
    end

    quote = Alphavantage::TimeSeries.new(symbol: ticker_symbol).quote

    quote.price
  end
end
