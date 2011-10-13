require 'erb'
require 'yaml'
require 'aedtweet'
require 'time'

$root_tweets = []

$inner_table = ""
File.open('inner_table.erb', 'r'){|f| 
  $inner_table = f.read
}

def render_inner_table(t)
  text = t.text
  replies = t.replies
  date = t.created_at.getlocal.to_s
  erb = ERB.new($inner_table)
  return erb.result(binding)
end

File.open('rebuilded.yaml', 'r'){|f|
  $root_tweets = YAML::load(f.read)
}

File.open('table.erb', 'r'){|f| 
  erb = ERB.new(f.read)
  o = File.open('result.html', 'w')
  o.write erb.result(binding)
  o.close
}
