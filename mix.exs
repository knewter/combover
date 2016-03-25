defmodule Combover.Mixfile do
  use Mix.Project

  def project do
    [app: :combover,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :hedwig_slack, :sasl, :extwitter],
     mod: {Combover, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:hedwig_slack, github: "hedwig-im/hedwig_slack"},
      {:extwitter, github: "knewter/extwitter"} # NOTE: I'm just using my fork to get around some dependency issues, this shouldn't happen in the future.
    ]
  end
end
