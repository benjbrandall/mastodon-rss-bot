# mastodon-rss-bot

The first part reads the list of RSS feed links from a file and loads them into an array:

    $old_timestamps =[]
    $feeds = []

    File.open('feeds').each_line{ |url|
    $feeds.push(url.chomp)
    }

Next, each feed URL's content is filtered to remove duplicates, parsed for its title and URL, and then fed line by line into a text file.

    def check_for_new_items

    $feeds.each do |feed|

      response = HTTParty.get feed # get the feed with HTTParty
      feed = RSS::Parser.parse response.body # put the feed content into the feed variable

        feed.items.each do |item|
          if $old_timestamps.include?(item.date) # break out of the loop if the article is a duplicate
            break
          else
            $old_timestamps.push(item.date)
            toot = "#{item.title} — #{item.link}"
            File.open("toots", "a") { |file| file.write("#{toot}\n")} # add the toot text to a file
            break
          end
        end
      end
    end

The second part of the program reads lines from the toots text file, toots them all out, and then clears the file. This ensures no duplicates can get through, because only unique items end up in the file and the file is wiped clean before each new entry.

    def toot
      client = Mastodon::REST::Client.new(base_url: "INSTANCE_URL", bearer_token: "BEARER_TOKEN")
      toots = File.open('toots').to_a
      toots.each do |toot|
        client.create_status(toot) # toot!
      end
        File.truncate('toots', 0) # clear the file
        sleep(900) # sleep for 15 minutes before checking for new items
    end

Most of the code above is reused from my [previous post about making a Mastodon bot in Ruby](http://benjbrandall.xyz/mastodon-bot-ruby/).

The main loop of the bot just calls `check_for_new_items` and then `toot` over and over again, with the toot method pausing for 15 minutes before looping.
