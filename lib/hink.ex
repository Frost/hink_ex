defmodule Hink do
  use Application

  def start(_type, _args),
    do: Hink.Supervisor.start_link
end
