defmodule Fifo.Server.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    port = Application.get_env(:fifo, :port)

    # {packet: :line} garantees that packages will be broken in several lines
    {:ok, listen} = :gen_tcp.listen(port, [{:active, :once}, {:packet, :line}])
    spawn_link(empty_listeners/0)

    children = [
      worker(Fifo.Server, listen, restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  @doc """
  `Supervisor.start_child/2` is used on the `simple_one_for_one` strategy
  """
  def start_socket do
    Supervisor.start_child(__MODULE__, [])
  end

  @doc """
  Starts 20 empty listeners right away
  """
  def empty_listeners do
    for _ <- 1..20, do: start_socket()
    :ok
  end
end
