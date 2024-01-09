class Stock < ApplicationRecord
  require 'alphavantage'

  def self.new_lookup(ticker_symbol)
    Alphavantage.configure do |config|
      config.api_key = Rails.application.credentials.alphavantage[:api_key]
    end

    Alphavantage::TimeSeries.new(symbol: ticker_symbol).quote
  end
end
