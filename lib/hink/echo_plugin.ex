defmodule Hink.EchoPlugin do
  require Logger
  
  def start_link(client),
  do: GenServer.start_link(__MODULE__, [client])
  
  def init([client]) do
    ExIrc.Client.add_handler(client, self)
    {:ok, client}
  end

  def handle_info({:mentioned, "hinx:" <> msg, sender, channel}, client) do
    echo(client, channel, sender <> ":" <> msg)
    {:noreply, client}
  end

  def handle_info({:received, "!echo" <> msg, _sender, channel}, client) do
    echo(client, channel, msg)
    {:noreply, client}
  end

  def handle_info(_msg, client), do: {:noreply, client}

  defp echo(client, channel, msg) do
    ExIrc.Client.msg(client, :privmsg, channel, String.strip(msg))
  end
end
