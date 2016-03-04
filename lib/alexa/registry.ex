defmodule Alexa.Registry do
  use GenServer

  def start_link do
    IO.puts "Starting Alexa.Registry"
    GenServer.start_link(__MODULE__, %{}, name: :alexa_registry)
  end

  def register_skill(app_id, module) do
    GenServer.cast(:alexa_registry, {:register_skill, app_id, module})
  end

  def get_skill(app_id) do
    GenServer.call(:alexa_registry, {:lookup_skill, app_id})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:register_skill, app_id, module}, state) do
    state = Map.put(state, app_id, module)
    {:noreply, state}
  end

  def handle_call({:lookup_skill, app_id}, _, state) do
    module = Map.get(state, app_id, Alexa.UnknownSkill)
    {:reply, module, state}
  end
end
