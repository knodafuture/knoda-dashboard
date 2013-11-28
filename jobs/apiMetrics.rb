require 'httparty'

SCHEDULER.every '5m' do
  response = HTTParty.get('http://api.knoda.com/api/metrics')
  send_event('users', { current:  response['userMetrics']['current'], last: response['userMetrics']['lag7']})
end