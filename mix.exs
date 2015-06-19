defmodule Hink.Mixfile do
  use Mix.Project

  def project do
    [app: :hink,
     version: "0.0.1",
     elixir: "~> 1.1-dev",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [ mod: {Hink, []},
			applications: [:logger, :exirc]]
  end

  defp deps do
    [{:exirc, "~> 0.9.1"},
		 {:ecto, "~> 0.11.0"}]
  end
end