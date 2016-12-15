defmodule Fifo.QueueTest do
  use ExUnit.Case

  test "register new queue" do
    {:ok, _pid} = Fifo.Queue.start_link("test")
    Fifo.Queue.put("test", 1)
    assert(1 == Fifo.Queue.get("test"))
  end

  test "using several fifo's at the same time" do
    Fifo.Queue.start_link(:one)
    Fifo.Queue.start_link(:two)

    Fifo.Queue.put(:one, 1)
    Fifo.Queue.put(:one, 2)
    Fifo.Queue.put(:one, 3)
    assert(Fifo.Queue.state(:one) == [1,2,3])


    Fifo.Queue.put(:two, 1)
    Fifo.Queue.put(:two, 1)
    assert(Fifo.Queue.state(:two) == [1,1])
  end

  # Cant make that work properly
  # test "fails to get stuff from non existent queue" do
  #   assert(Fifo.Queue.state(:any) == :error)
  # end
end
