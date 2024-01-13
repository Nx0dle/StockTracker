class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through:  :user_stocks

  validates :name, :ticker, presence: true

  def self.iex_new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
      publishable_token: "pk_265abf4131ce4b20b209b572159ae167",
      secret_token: Rails.application.credentials.iex_api[:secret_api_key],
      endpoint: 'https://cloud.iexapis.com/v1'
    )

    begin
      new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol))
    rescue => exception
      return nil
    end
  end

  def self.alpha_new_lookup(ticker_symbol)
    require 'alphavantage'
    Alphavantage.configure do |config|
      config.api_key = Rails.application.credentials.alpha_api[:secret_api_key]
    end

    quote = Alphavantage::TimeSeries.new(symbol: ticker_symbol).quote

    if !quote.symbol.nil?
      new(ticker: quote.symbol, name: "undef", last_price: quote.price)
    else
      return nil
    end
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
end
