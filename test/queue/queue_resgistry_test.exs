defmodule Fifo.QueueRegistryTest do
  use ExUnit.Case

  setup do
    {:ok, registry} = Fifo.QueueRegistry.start_link
    {:ok, registry: registry}
  end

  test "creates queues", %{registry: registry} do
    assert(Fifo.QueueRegistry.lookup(registry, "test") == :error)

    Fifo.QueueRegistry.create(registry, "my_queue")
    assert({:ok, queue_pid} = Fifo.QueueRegistry.lookup(registry, "my_queue"))

    Fifo.Queue.put(queue_pid, 110)
    assert(Fifo.Queue.get(queue_pid) == 110)
  end
end
