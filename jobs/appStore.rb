require 'httparty'

SCHEDULER.every '30m' do
  options = {:basic_auth => {:username => 'support@knoda.com', :password => 'Kn0daf$t$re'}}
  r = HTTParty.get("https://api.appfigures.com/v2/sales/dates/-7/0/?client_key=f7b4c785521e444aaf67ed5e8c1838fa", options).values
  totalResponse = HTTParty.get("https://api.appfigures.com/v2/sales/?client_key=f7b4c785521e444aaf67ed5e8c1838fa", options)
  x = []
  total = r[0]['downloads'] + r[1]['downloads'] + r[2]['downloads'] + r[3]['downloads'] + r[4]['downloads'] + r[5]['downloads'] + r[6]['downloads']
  x << { label: 'Yesterday', value: r[r.length-2]['downloads']}
  x << { label: '7 day average', value: total/7}
  x << { label: 'Total', value: totalResponse['downloads']}
  send_event('appstore-downloads', { items: x})
end