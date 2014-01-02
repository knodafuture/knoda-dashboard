require 'httparty'

SCHEDULER.every '5m' do
  response = HTTParty.get('http://api.knoda.com/api/metrics')
  send_event('users', { current:  response['userMetrics']['current'], last: response['userMetrics']['lag7']})
  c = (response['commentRatio']['current']*100).to_i / 100.0
  ch = (response['challengeRatio']['current']*100).to_i / 100.0
  send_event('comments', {current: c})
  send_event('challenges', {current: ch})
  predictionCats(response)
end

def predictionCats(response)
  pc = []
  total = 0
  response['categories'].each do |c|
  	total = total + c['count']
  end  
  pc << {label: 'Total', value: total}
  response['categories'].each do |c|
  	percentageOfTotal = ((c['count'].to_f / total.to_f) * 100.0).floor
  	pc << {label: c['name'], value: "#{percentageOfTotal}%"}
  end
  send_event('prediction-categories', {items: pc})
end