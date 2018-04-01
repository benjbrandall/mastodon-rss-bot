require 'rss'
require 'httparty'
require_relative 'tootbot'

$old_timestamps = []
$feeds = []

File.open('feeds').each_line{ |url|
  $feeds.push(url.chomp)
}

def check_for_new_items

  $feeds.each do |feed|

    response = HTTParty.get feed
    feed = RSS::Parser.parse response.body

      feed.items.each do |item|
      if $old_timestamps.include?(item.date)
        break
      else
      $old_timestamps.push(item.date)
      toot = "#{item.title} — #{item.link}"
      File.open("toots", "a") { |file| file.write("#{toot}\n")}
        break
      end
    end
  end
end

while true
check_for_new_items
toot
end
