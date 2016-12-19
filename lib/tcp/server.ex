defmodule Fifo.Server do
  use GenServer

  def start_link(socket) do
    require IEx; IEx.pry
    GenServer.start_link(__MODULE__, socket, [])
  end

  def init(socket) do
    GenServer.cast(self(), :listener)
    {:ok, socket}
  end

  def handle_cast(:listener, socket) do
    # require IEx; IEx.pry
    {:ok, accept} = :gen_tcp.accept(socket)
    # Fifo.Server.Supervisor.start_socket() # starts a new child
    # listen with once, query the user with the welcome message
    send_message(accept, "Welcome, queue created for you?", [])
    {:noreply, socket}
  end

  def handle_call(_, _from, state) do
    require IEx; IEx.pry
    {:noreply, state}
  end

  def handle_info({:tcp, socket, "quit" <> _}) do
    require IEx; IEx.pry
    :gen_tcp.close(socket)
    {:noreply, ""}
  end

  def handle_info({:tcp, socket, msg}) do
    require IEx; IEx.pry
    :gen_tcp.send(socket, msg)
  end

  defp send_message(socket, message, _args) do
    :gen_tcp.send(socket, message)
    :inet.setopts(socket, active: :once)
  end
end
