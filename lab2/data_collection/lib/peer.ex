# Modify to support data collection, where the root collects dataa from other peers
# Change Peer to count the number of child peers that a peer has


defmodule Peer do
 
  # add your code here, start(), next() and any other functions
  def start(node_id) do 
    # init
    IO.puts "-> Peer at #{Helper.node_string()}, Node ID:  #{node_id}, PID: #{inspect(self())}"
    receive do
      {:neighbors, neighbors} -> next(node_id, neighbors)
    end
  end # start

  defp next(node_id, neighbors) do
    # Peer should forward the first :hello message it receives to all neighbors
    # change peer so that it remembers from whom it receives its first :hello, i.e. remember the parent
    receive do
      {:root, neighbors} -> 
        IO.puts "Root found, peer #{node_id}, #{inspect(self())}..."
        Enum.map(neighbors, fn n -> 
          send n, {:parent, self(), node_id}
        end)
        count(0, node_id) 
      
      {:parent, parent, parent_id} ->
        send parent, {:child}
        Enum.map(neighbors, fn n -> 
          send n, {:parent, self(), node_id} 
        end)

        count(0, node_id, parent, parent_id)

    end
  end # next

  # Current = number of child nodes
  defp count(current, node_id) do
    receive do
      {:child} -> count(current+1, node_id) # recursively increment current
    after
      # 1_000 -> IO.puts "Peer #{inspect(self())} is a root, Messages seen = #{current}..."
      1_000 -> IO.puts "Peer #{node_id} is a root, Children = #{current}..."
      count(current, node_id)
    end
  end # count, for root node

  defp count(current, node_id, parent, parent_id) do
    receive do
      {:child} -> count(current+1, node_id, parent, parent_id) # recursively increment current
    after
      # 1_000 -> IO.puts "Peer #{inspect(self())} has Parent #{inspect(parent)}, Messages seen = #{current}..."
      1_000 -> IO.puts "Peer #{node_id} has Parent #{parent_id}, Children = #{current}..."
      count(current, node_id, parent, parent_id)
    end
  end # count, for non-root node

end # module ------------------------

