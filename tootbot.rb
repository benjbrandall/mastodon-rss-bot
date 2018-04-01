require 'rubygems'
require 'bundler/setup'
require 'mastodon'

def toot
  client = Mastodon::REST::Client.new(base_url: "https://botsin.space", bearer_token: "BEARER_TOKEN")
  toots = File.open('toots').to_a
  toots.each do |toot|
    client.create_status(toot)
  end
    File.truncate('toots', 0)
    sleep(900)
  end
