defmodule Fifo.Tcp do
  def start_server(port) do
    pid = spawn(fn ->
      {:ok, listen} = :gen_tcp.listen(port, [:binary, {:active, false}])
      spawn(fn -> listener(listen) end)
      :timer.sleep(:infinity)
    end)
    {:ok, pid}
  end

  def listener(listen_socket) do
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    spawn(fn -> listener(listen_socket) end)
    handle(socket)
  end

  def handle(socket) do
    :inet.setopts(socket, [{:active, :once}])
    receive do
      {:tcp, socket, "quit" <> _} ->
        :gen_tcp.close(socket)
      {:tcp, socket, msg} ->
        :gen_tcp.send(socket, msg)
        handle(socket) # Keep listening
    end
  end
end
