defmodule Combover.TwitterUsers do
  use GenServer

  @registered_name __MODULE__

  ## Public API

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, [name: @registered_name])
  end

  def add({username, channel}) do
    GenServer.call(@registered_name, {:add, {username, channel}})
  end

  def list do
    GenServer.call(@registered_name, :list)
  end

  ## Internal API

  def init(tracking \\ %{}) do
    {:ok, tracking}
  end

  def handle_call({:add, {username, channel}}, _from, state) do
    if Map.has_key?(state, {username, channel}) do
      {:reply, :ok, state}
    else
      start_twitter_stream({username, channel})
      {:reply, :ok, Map.put(state, {username, channel}, username)}
    end
  end

  def handle_call(:list, _from, state) do
    {:reply, Map.keys(state), state}
  end

  defp start_twitter_stream({username, channel}) do
    spawn_link(fn() ->
      ExTwitter.stream_filter(track: "nintendo")
      |> Stream.map(fn(tweet) ->
        case Hedwig.Registry.whereis(Combover.Robot) do
          nil -> :ok
          robot ->
            message =
              %Hedwig.Message{
                adapter: Hedwig.Adapters.Slack,
                robot: robot,
                room: channel,
                type: "message",
                text: "https://twitter.com/statuses/#{tweet.id}"
              }
            Combover.Robot.send(robot, message)
        end
      end)
      |> Stream.run
    end)
  end
end
