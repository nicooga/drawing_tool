ExUnit.start()

defmodule UUIDGeneratorTest do
  use ExUnit.Case

  @concurrency 10
  @iterations 1000

  test "it works" do
    pid = UUIDGenerator.start_server()

    Enum.each(1..10, fn n ->
      assert UUIDGenerator.generate(pid) == n
    end)

    UUIDGenerator.stop_server(pid)
  end

  test "it performs well under concurrency" do
    pid = UUIDGenerator.start_server()

    Enum.each(1..@iterations, fn i ->
      expected_min_id = (i - 1) * @concurrency + 1
      expected_max_id = i * @concurrency
      expected_id_range = expected_min_id..expected_max_id

      tasks =
        Enum.map(1..@concurrency, fn _j ->
          Task.async(fn -> UUIDGenerator.generate(pid) end)
        end)

      generated_ids = Enum.map(tasks, &Task.await/1)

      Enum.each(generated_ids, fn id -> 
        assert Enum.member?(expected_id_range, id)
      end)

      unique_generated_ids = MapSet.new(generated_ids)

      assert MapSet.size(unique_generated_ids) == @concurrency
    end)


    UUIDGenerator.stop_server(pid)
  end
end