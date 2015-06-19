defmodule Hink.LoginHandler do
	def start_link(client, channels),
	  do: GenServer.start_link(__MODULE__, [client, channels])
	
  def init([client, channels]) do
		ExIrc.Client.add_handler(client, self)
		{:ok, {client, channels}}
  end

	def handle_info(:logged_in, state = {client, channels}) do
		debug "Logged in to server"
		Enum.map(channels, &ExIrc.Client.join(client, &1))
		{:noreply, state}
	end

	def handle_info(_msg, state),
		do: {:noreply, state}

	defp debug(msg),
	  do: IO.puts(IO.ANSI.yellow <> msg <> IO.ANSI.reset)
end
