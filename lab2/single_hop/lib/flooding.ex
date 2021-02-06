# flood message through 1-hop (fully connected) network

defmodule Flooding do

  def start do 
    config = Helper.node_init()
    start(config.start_function, config) 
  end # start/0

  defp start(:cluster_wait, _), do: :skip
  defp start(:cluster_start, config) do
  
    # Create 10 peer processes (each running on its own node) 
    # that passes its neighbors (including itself) to all the 
    # other peers

    IO.puts "Creatiing peers..."
    n_peers = config.n_peers
    
    peer_map = Enum.map(1..n_peers, fn _ -> 
      spawn(Peer, :start, []) 
    end)
    IO.puts "#{n_peers} peers spawned..."
    send Enum.at(peer_map, 0), {:hello, peer_map} # send hello message to the first peer
    Process.sleep(10000)
    IO.puts "Connection ended."

  end # start

end # module -----------------------

