defmodule Hink.PluginHandler do
	use GenServer
	import Supervisor.Spec

	def start_link(client) do
		GenServer.start_link(__MODULE__, [client: client], [name: __MODULE__])
	end

	def init([client: client]) do
		{:ok, [client: client]}
	end

	def enable_plugin(plugin) do
		GenServer.cast(__MODULE__, {:add_plugin, plugin})
	end

	def disable_plugin(plugin) do
		:ok = Supervisor.terminate_child(Hink.PluginSupervisor, plugin)
		:ok = Supervisor.delete_child(Hink.PluginSupervisor, plugin)
	end

	def handle_cast({:add_plugin, plugin}, [client: client] = state) do
		{:ok, child} = Supervisor.start_child(
			 Hink.PluginSupervisor,
			 worker(plugin, [client]))
		{:noreply, state}
	end
end
