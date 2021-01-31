
# distributed algorithms, n.dulay, 4 jan 21
# simple client-server, v1

defmodule Client do

def start do
  IO.puts "-> Client at #{Helper.node_string()}"
  receive do
  { :bind, server } -> next(server)
  end
end

defp next(server) do
  send server, { :circle, 1.0 }
  receive do { :result, area } -> IO.puts "Area is #{area}" end
  Process.sleep(1000)
  next(server)
end

end # module -----------------------

