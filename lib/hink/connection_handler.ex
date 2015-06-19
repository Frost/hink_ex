defmodule Hink.ConnectionHandler do
	defmodule State do
		defstruct host: "efnet.port80.se",
		          port: 6667,
		          pass: "",
		          nick: "hinx",
		          user: "hinx",
		          name: "hinx",
		          client: nil
	end

	def start_link(client, state \\ %State{}),
	  do: GenServer.start_link(__MODULE__, [%{state | client: client}])

	def init([state]) do
		ExIrc.Client.add_handler(state.client, self)
		ExIrc.Client.connect!(state.client, state.host, state.port)
		{:ok, state}
	end

	def handle_info({:connected, server, port}, state) do
		debug "Connected to #{server}:#{port}"
		ExIrc.Client.logon(state.client, state.pass, state.nick, state.user, state.name)
		{:noreply, state}
	end

	def handle_info(msg, state) do
		debug "Received unknown message:"
		IO.inspect(msg)
		{:noreply, state}
	end

	defp debug(msg),
	  do: IO.puts(IO.ANSI.yellow <> msg <> IO.ANSI.reset)
end
