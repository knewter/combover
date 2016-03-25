defmodule Combover.Responders.Twitter do
  @moduledoc false

  use Hedwig.Responder
  alias Combover.TwitterUsers

  @usage """
  hedwig: track <user> - Track a given Twitter user's tweets
  """
  respond ~r/track (.*)/i, msg do
    username = msg.matches[1]
    TwitterUsers.add({username, msg.room})
    reply msg, "I'll track #{username}!"
  end

  @usage """
  hedwig: list twitter users - List the twitter users being tracked
  """
  respond ~r/list twitter users/i, msg do
    users = TwitterUsers.list
    reply msg, "I'm presently tracking: #{inspect users}"
  end
end
