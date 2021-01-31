
# distributed algorithms, n.dulay, 4 jan 18
# simple client-server, v1

defmodule Server do
 
def start do 
  IO.puts "-> Server at #{Helper.node_string()}, #{inspect(self())}"
  next()
end # start
 
defp next() do
# 25 (i) send results to requesting client's PID (is first element of client's msg)
  receive do
  { :circle, clientPID, radius } -> 
    send clientPID, { :result, 3.14159 * radius * radius }
  { :square, clientPID, side } -> 
    send clientPID, { :result, side * side }
  end
  next()
end # next

end # module -----------------------

