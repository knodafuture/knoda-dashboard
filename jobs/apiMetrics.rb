require 'httparty'

SCHEDULER.every '10s' do
  response = HTTParty.get('http://api.knoda.com/api/metrics')
  send_event('users', { current:  response['userMetrics']['current'], last: response['userMetrics']['lag7']})
  c = (response['commentRatio']['current']*100).to_i / 100.0
  ch = (response['challengeRatio']['current']*100).to_i / 100.0
  send_event('comments', {current: c})
  send_event('challenges', {current: ch})
end