defmodule Hink do
	#use Application

	def start(_type, _args) do
		import Supervisor.Spec, warn: false

		{:ok, client} = ExIrc.start_client!

		children = [
			worker(Hink.ConnectionHandler, [client]),
		  worker(Hink.LoginHandler, [client, ["#beerhazard"]])]

		opts = [strategy: :one_for_one, name: Hink.Supervisor]
		Supervisor.start_link(children, opts)
	end
end
