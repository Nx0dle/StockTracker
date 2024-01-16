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

  def self.twelve_data_new_lookup(ticker_symbol)
    require 'httparty'
    api_key = Rails.application.credentials.twelve_api[:secret_api_key]
    endpoint = "https://api.twelvedata.com/"

    company_response = HTTParty.get("#{endpoint}stocks?symbol=#{ticker_symbol}&apikey=#{api_key}")
    response = HTTParty.get("#{endpoint}time_series?symbol=#{ticker_symbol}&interval=1min&outputsize=5000&apikey=#{api_key}")

    if response.code == 200
      company_body = JSON.parse(company_response.body)
      company_name = company_body['data'].first['name']
      data = JSON.parse(response.body)
      new(ticker: data['meta']['symbol'], name: company_name, last_price: data['values'].last['close'].to_f.round(2))
    else
      return nil
    end
  rescue => exception
    return nil
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
end
