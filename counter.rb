require 'rubygems'
require 'twitter'
require 'yaml'

$tweets = {}

Twitter.configure do |config|
  config.proxy = 'http://202.94.100.180:80'
end

Twitter.user_timeline('kaoricky25')

File.open('db.yaml', 'r'){|f|
  $tweets = YAML::load(f.read)
}

p $tweets.size

