defmodule Hink.PluginSupervisor do
	use Supervisor

	def start_link(client) do
		Supervisor.start_link(__MODULE__, [client: client], [name: __MODULE__])
	end

	def init([client: client]) do
		children = Application.get_env(:hink, :plugins) ++ [Hink.PluginHandler]
		           |> Enum.map(fn plugin -> worker(plugin, [client]) end)

		supervise(children, [strategy: :one_for_one])
	end
end
