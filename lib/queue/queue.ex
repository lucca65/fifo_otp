defmodule Fifo.Queue do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: {:global, name})
  end

  def init(state) do
    {:ok, state} # put initial state here
  end

  # It would be in/out, but `in` is a reserved word
  def put(queue_name, elem) do
    GenServer.call({:global, queue_name}, {:put, elem})
  end

  def get(queue_name) do
    GenServer.call({:global, queue_name}, :get)
  end

  def state(queue_name) do
    GenServer.call({:global, queue_name}, :state)
  end

  def kill(queue_name) do
    GenServer.stop({:global, queue_name})
  end

  # Server
  def handle_call({:put, elem}, _from, state) do
    {:reply, state} = put_elem(state, elem)
    {:reply, :ok, state}
  end

  def handle_call(:get, _from, state) do
    get_elem(state)
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_info({:DOWN, _ref, :process, pid, reason}, state) do
    "DOWN: from pid(#{pid}). \n\nREASON: #{reason})" |> IO.puts
    {:noreply, state}
  end

  defp put_elem(state, new_elem) do
    state = state ++ [new_elem]
    {:reply, state}
  end

  defp get_elem(state) do
    [elem|rest] = state
    {:reply, elem, rest}
  end
end
