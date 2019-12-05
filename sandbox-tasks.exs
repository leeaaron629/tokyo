defmodule MyModule do
  def long_task(x) do
    for n <- 1..x do
      :timer.sleep(1000)
      IO.puts "Sleeping #{n} sec"
      n
    end
    |> List.last
  end
end

task = Task.async(MyModule, :long_task, [10])

res = Task.await(task, 11000)

IO.puts "Result: #{res}"

