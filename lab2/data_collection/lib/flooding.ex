defmodule Flooding do

  def start do 
    config = Helper.node_init()
    start(config.start_function, config) 
  end # start/0

  defp start(:cluster_wait, _), do: :skip
  defp start(:cluster_start, config) do
  
    # Create 10 peer processes (each running on its own node) 
    # that passes its neighbors (including itself) to all other peers

    IO.puts "Creatiing peers..."
    n_peers = config.n_peers
    
    peer_list = Enum.map(1..n_peers, fn index -> 
      spawn(Peer, :start, [index-1]) 
    end)
    IO.puts "#{n_peers} peers spawned..."

    # setup multi-hop network config
    bind(peer_list, 0, [1, 6])
    bind(peer_list, 1, [0,2,3])
    bind(peer_list, 2, [1,3,4])
    bind(peer_list, 3, [1,2,5])
    bind(peer_list, 4, [2])
    bind(peer_list, 5, [3])
    bind(peer_list, 6, [0,7])
    bind(peer_list, 7, [6,8,9])
    bind(peer_list, 8, [7, 9])
    bind(peer_list, 9, [7, 8])

    # send Enum.at(peer_list, 0), {:hello, Enum.at(peer_list, 0)} # send hello message to the first peer
    Process.sleep(15000)
    IO.puts "Connection ended."

  end # start

  defp bind(peer_list, id, neighbor_ids) do
    peer = Enum.at(peer_list, id) # obtain peer node from id
    neighbors = Enum.map(neighbor_ids, fn i -> Enum.at(peer_list, i) end) # list of neighbor nodes
    send peer, {:neighbors, neighbors}
    if id == 0 do 
      send peer, {:root, neighbors} # builds parent-child relationships
    end 
  end # bind

end # module -----------------------

