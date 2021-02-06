
# distributed algorithms, n.dulay, 4 jan 21
# basic flooding, v1

# flood message through 1-hop (fully connected) network

defmodule Flooding do

def start do 
  config = Helper.node_init()
  start(config.start_function, config) 
end # start/0

defp start(:cluster_wait, _), do: :skip
defp start(:cluster_start, config) do
  IO.puts "-> Flooding at #{Helper.node_string()}"

  # add your code here

end # start

end # module -----------------------

