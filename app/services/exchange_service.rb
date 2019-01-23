require 'rest-client'
require 'json'

class ExchangeService
  def initialize(source_currency, target_currency, amount)
    @source_currency = source_currency
    @target_currency = target_currency
    @amount = amount.to_f
  end


  def perform
    if [@source_currency, @target_currency].include?('BTC')
      perform_btc_currency_exchange
    else
      perform_normal_currency_exchange
    end
  end

  private

  def perform_normal_currency_exchange
    begin
      exchange_api_url = Rails.application.credentials[Rails.env.to_sym][:currency_api_url]
      exchange_api_key = Rails.application.credentials[Rails.env.to_sym][:currency_api_key]
      url = "#{exchange_api_url}?token=#{exchange_api_key}&currency=#{@source_currency}/#{@target_currency}"
      res = RestClient.get url
      value = JSON.parse(res.body)['currency'][0]['value'].to_f
      value * @amount
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end

  def perform_btc_currency_exchange
    begin
      currency = if @source_currency == "BTC"
                   @target_currency
                 else
                   @source_currency
                 end

      btc_api_url = Rails.application.credentials[Rails.env.to_sym][:btc_api_url]
      url = "#{btc_api_url}?currency=#{currency}&value=1"
      res = RestClient.get url
      value = res.body.to_f

      if @source_currency == "BTC"
        @amount / value
      else
        @amount * value
      end
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end
end
