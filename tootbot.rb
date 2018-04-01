require 'rubygems'
require 'bundler/setup'
require 'mastodon'

def toot
  client = Mastodon::REST::Client.new(base_url: "https://botsin.space", bearer_token: "eeaf1a6901476516d21aa9745f10c44cd15ae1b385e661c8a3c403f95a965ab2")
  toots = File.open('toots').to_a
  toots.each do |toot|
    client.create_status(toot)
  end
    File.truncate('toots', 0)
    sleep(900)
  end
