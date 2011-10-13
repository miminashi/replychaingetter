require 'rubygems'
require 'twitter'
require 'yaml'
require 'pp'
#require 'aedtweet'

PER_PAGE = 200

$tweets = {}

def gettimeline(min_id=nil)
  if min_id
    opts = {:count => PER_PAGE, :max_id => min_id-1}
  else
    opts = {:count => PER_PAGE}
  end

  tl = Twitter.user_timeline('kaoricky25', opts)
  tl.each do |t|
    #$tweets[t.id] = AEDTweet.new(:id => t.id, :in_reply_to_id => t.in_reply_to_status_id, :text => t.text)
    $tweets[t.id] = t

=begin
    puts t.user.screen_name
    puts t.text
    puts t.id
    puts t.in_reply_to_status_id_str.to_i
    puts
=end
  end

  unless tl.size < PER_PAGE
    puts "load next page..."
    gettimeline(tl[-1].id)
  end
end

gettimeline

tweets_yaml = $tweets.to_yaml
f = File.open('db.yaml', 'w')
f.write tweets_yaml
f.close

p $tweets.size

