defmodule Fifo.Tcp do
  def start_server(listen) do
    pid = spawn(fn ->
      spawn(fn -> listener(listen) end)
      :timer.sleep(:infinity) # keeping father process alive
    end)
    {:ok, pid}
  end

  def listener(listen_socket) do
    {:ok, accept} = :gen_tcp.accept(listen_socket)
    # This way we will always have another process listining
    spawn(fn -> listener(listen_socket) end)
    handle(accept)
  end

  @doc """
  Echoes back what is called

  ### Dev commentary

  Sets sockets as `{:active, :one}`so it will only stay open until one given message comes. Then it decides whether it will close it or keep listenting actively

  Also, we can try out using {:active, N}, since we can wait N packages before going passive again

  Just keep in mind that this counter is culmultative to the current socket
  so recursing might bug you. Try using negative values {:active, -10}
  """
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
