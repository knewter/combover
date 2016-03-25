defmodule Combover.Robot do
  use Hedwig.Robot, otp_app: :combover

  def after_connect(state) do
    IO.puts "got after_connect"
    Hedwig.Robot.register(self, __MODULE__)
    {:ok, state}
  end
end
