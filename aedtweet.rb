class AEDTweet
  def initialize(opts)
    @screen_name = opts[:screen_name]
    @t_id = opts[:t_id]
    @in_reply_to_status_id = opts[:in_reply_to_status_id]
    @text = opts[:text]
    @created_at = opts[:created_at]
    @replies = []
  end
  attr_reader :t_id, :text, :in_reply_to_status_id, :screen_name, :replies, :created_at

  def add_reply(reply)
    @replies << reply
  end
end

