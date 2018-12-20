require 'rails_helper'

RSpec.describe "Exchange Currency Process", :type => :system, js: true do
  it "exchange value" do
    visit '/'
    within("#exchange_form") do
      select('EUR', from: 'source_currency')
      select('USD', from: 'target_currency')
      fill_in 'amount', with: '10'
    end

    expect(page.find_by_id('result').value).to eq('34.1325')
  end
end
