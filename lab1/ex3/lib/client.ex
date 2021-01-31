
# distributed algorithms, n.dulay, 4 jan 21
# simple client-server, v1
# Pass clients the server's process-id in either an initial :bind message or simpler still
# pass the server’s process-id as a parameter to all spawned client processes in ClientServer.

defmodule Client do

# receive arg server as input arg from node.spawn in clientserver.ex
def start(server) do
  IO.puts "-> Client at #{Helper.node_string()}, #{inspect(self())}"
  next(server)
end

defp next(server) do
  if Helper.random(2) == 1 do
    send server, { :square, self(), Helper.random(10)}
  else
    send server, { :circle, self(), Helper.random(5) } # 24 (i) add client pid as first arg
  end
  receive do 
    { :result, area } -> IO.puts "Area is #{area} (#{inspect(self())})" 
  end # 24 (iii)
  Process.sleep(1000*Helper.random(3))
  next(server)
end

end # module -----------------------

