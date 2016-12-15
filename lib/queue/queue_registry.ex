defmodule Fifo.QueueRegistry do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def lookup(registry, name) do
    GenServer.call(registry, {:lookup, name})
  end

  def create(registry, name) do
    GenServer.cast(registry, {:create, name})
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:lookup, name}, _from, state) do
    {:reply, Map.fetch(state, name), state}
  end

  def handle_cast({:create, name}, state) do
    if Map.has_key?(state, name) do
      {:noreply, state}
    else
      {:ok, queue_pid} = Fifo.Queue.start_link(name)
      {:noreply, Map.put(state, name, name)}
    end
  end
end
