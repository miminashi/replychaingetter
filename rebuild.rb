require 'rubygems'
require 'twitter'
require 'yaml'
require 'aedtweet'
require 'pp'
require 'time'

FILE_NAME = 'db.yaml'

Twitter.configure do |config|
  config.proxy = 'http://81.30.55.149:80'
end

$tweets = {}
$root_tweets = []

def aedtweet_new(t)
  r = AEDTweet.new(
    :t_id => t.id,
    :screen_name => t.user.screen_name,
    :text => t.text,
    :in_reply_to_status_id => t.in_reply_to_status_id,
    :created_at => Time.parse(t.created_at)
  )
  return r
end

#
# root, t ともにAEDTweet
#
def add_tweet(root, t)
  if root.t_id == t.in_reply_to_status_id
    root.add_reply(t)
  else
    root.replies.each do |reply|
      add_tweet(reply, t) 
    end
  end
end

Twitter.user_timeline('kaoricky25')

File.open('db.yaml', 'r'){|f|
  $tweets = YAML::load(f.read)
}

# root tweetを抜き出す
$tweets.each do |k, t|
  unless t.in_reply_to_status_id
    $root_tweets << aedtweet_new(t)
  end
end
$tweets.reject!{|k, v| v.in_reply_to_status_id == nil}

# root tweetにreplyをナニする 
while($tweets.size > 0)
  k, t = $tweets.shift
  $root_tweets.each do |root|
    add_tweet(root, aedtweet_new(t))
  end
  p $tweets.size
end

f = File.open('rebuilded.yaml', 'w')
f.write $root_tweets.sort{|a, b| a.created_at <=> b.created_at}.to_yaml
f.close

