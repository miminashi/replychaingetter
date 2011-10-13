require 'rubygems'
require 'twitter'
require 'yaml'
#require 'aedtweet'
require 'pp'

MY_SCREEN_NAME = 'kaoricky25'
FILE_NAME = 'db.yaml'

Twitter.configure do |config|
 # config.consumer_key = 'MeFAgRf2jyCb3aMT9AT4pQ'
 # config.consumer_secret = 'IoCPYHIgZQWKQ14jL5QAIj5xK2nIFVNPsXkO1N5mYI'
 # config.oauth_token = '28524511-Ry07lOEROv1vRsOPMBU5vTHh7EXij3HvDmXRs7SdY'
 # config.oauth_token_secret = '28524511-Ry07lOEROv1vRsOPMBU5vTHh7EXij3HvDmXRs7SdY'
  #config.proxy = '81.30.55.149'
  #config.proxy = 'http://202.94.100.180:80'
end

#$client = Twitter::Client.new

$buff = {}
$abort_flug = false

def print_tweet(t)
  puts t.id
  puts t.text
  puts t.in_reply_to_status_id
  puts
end

#def getreply(t)
#  if reply = $tweets[t.in_reply_to_status_id]
#    getreply(reply)
#  elsif reply = $buff[t.in_reply_to_status_id]
#    getreply(reply)
#  else
#    begin
#            reply = Twitter.status(t.in_reply_to_status_id)
#=begin
#      reply = AEDTweet.new(
#        :id => reply_t.id, 
#        :in_reply_to_id => reply_t.in_reply_to_status_id, 
#        :text => reply_t.text
#      )
#=end
#      #print_tweet(reply)
#      $buff[reply.id] = reply
#      if reply.in_reply_to_status_id
#        getreply(reply)
#      end
#    rescue Twitter::NotFound
#      puts t.in_reply_to_status_id.to_s + ' Not Found'
#      puts
#    end
#  end
#end

def get_in_reply_to(t)
  if t
    id = t.in_reply_to_status_id
    if id
      if r = $tweets[id]
        get_in_reply_to(r)
      elsif $buff[id]
        get_in_reply_to(r)
      else
        begin
          limit_status = Twitter.rate_limit_status
          if limit_status.remaining_hits < 10
            puts "reset time: #{limit_status.reset_time}"
            $abort_flug = true
          end
          puts "のこり #{limit_status.remaining_hits} APIs"

          r = Twitter.status(id)
          $buff[r.id] = r
          pp r
          puts
          get_in_reply_to(r)
        rescue => e
          p e
        end
      end
    end
  end
end

Twitter.user_timeline(MY_SCREEN_NAME)

File.open(FILE_NAME, 'r'){|f|
  $tweets = YAML::load(f.read)
}

pre_size = $tweets.size

$tweets.each do |id, t|
  break if $abort_flug

=begin
  if t.in_reply_to_status_id
    getreply(t)
  end
=end
  get_in_reply_to(t)

  #puts 'root tweet'
  #print_tweet(t)
end

$buff.each do |k, v|
  $tweets[k] = v
end

tweets_yaml = $tweets.to_yaml
f = File.open(FILE_NAME, 'w')
f.write tweets_yaml
f.close

puts "#{$tweets.size - pre_size} new tweets"

