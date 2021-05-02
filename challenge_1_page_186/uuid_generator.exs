defmodule UUIDGenerator do
  def server(last_used_id \\ 0) do
    new_id = last_used_id + 1

    receive do
      pid -> send(pid, new_id)
    end

    server(new_id)
  end

  def start_server, do: spawn(UUIDGenerator, :server, [])
  def stop_server(server_pid), do: Process.exit(server_pid, :kill)

  def generate(server_pid) do
    send(server_pid, self())

    receive do
      id -> id
    end
  end
end