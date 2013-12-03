require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = '0eorTHIaiDlZsNWDqpTQ'
  config.consumer_secret = 'rmTieBJrIb7J93a2sGiVZcoxj3Ze1CeOWsO9c4sqSxc'
  config.oauth_token = '109154946-cOwtPYT9RwNaA0uBuyLMzuTUpqtrepo3kLmFKFkx'
  config.oauth_token_secret = 'JTtB34KReOMBzR5N5LhKiUf4ykUGZOBwRQKWwBggn7xB3'
end

search_term = URI::encode('knoda')

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end