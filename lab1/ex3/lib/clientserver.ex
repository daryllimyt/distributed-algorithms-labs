
# distributed algorithms, n.dulay, 4 jan 21
# simple client-server, v1

defmodule ClientServer do

def start do 
  config = Helper.node_init()
  start(config.start_function, config) 
end

defp start(:single_start, config) do
  IO.puts "-> ClientServer at #{Helper.node_string()}"
  server = Node.spawn(:'clientserver_#{config.node_suffix}', Server, :start, [])
  # spawn N client processes
  for _ <- 1..config.clients, do: 
    Node.spawn(:'clientserver_#{config.node_suffix}', Client, :start, [server])
end

defp start(:cluster_wait, _), do: :skip
defp start(:cluster_start, config) do
  IO.puts "-> ClientServer at #{Helper.node_string()}"
  server = Node.spawn(:'server_#{config.node_suffix}', Server, :start, [])
  for i <- 1..config.clients, do: 
    Node.spawn(:'client#{i}_#{config.node_suffix}', Client, :start, [server])
end

end # module -----------------------

