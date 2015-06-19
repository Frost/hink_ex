defmodule Hink.Supervisor do
	use Supervisor

	def start_link do
		Supervisor.start_link(__MODULE__, [])
	end

	def init([]) do
		{:ok, client} = ExIrc.start_client!

		children = [
      worker(Hink.ConnectionHandler, [client]),
      worker(Hink.LoginHandler, [client, ["#beerhazard"]]),
      worker(Hink.EchoHandler, [client])
		]

		opts = [strategy: :one_for_one, name: Hink.Supervisor]
		supervise(children, opts)
	end
end
