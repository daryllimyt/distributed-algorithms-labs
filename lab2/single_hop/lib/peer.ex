defmodule Peer do
 
  # add your code here, start(), next() and any other functions
  def start do 
    # init
    IO.puts "-> Peer at #{Helper.node_string()}, #{inspect(self())}"
    next()
  end # start

  defp next do
    # Peer should forward the first :hello message it receives to all neighbors
    receive do
      {:hello, peer_map} -> 
        IO.puts "Peer #{inspect(self())} received first message..."
        IO.puts "Peer #{inspect(self())} flooding..."
        Enum.map(peer_map, fn peer_idx -> 
          send peer_idx, {:hello, peer_map}
        end)
        count(1) # initialize count
    end
  end # next

  defp count(current) do
    receive do
      {:hello, _} -> count(current+1) # recursively increment current
    after
      1_000 -> IO.puts "Peer #{inspect(self())} Messages seen = #{current}"
      count(current)
    end
  end # count

end # module ------------------------

