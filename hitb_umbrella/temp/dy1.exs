# https://elixirschool.com/en/lessons/specifics/mnesia/
# http://www.culttt.com/2016/10/12/working-mnesia-elixir/
IO.puts("======mnesia test=====")
:mnesia.start()
# :mnesia.info()
# t1 = fn -> :mnesia.table(:block_chain) end
# t1 = fn -> :mnesia.table_info(:block_chain, :all) end
# t1 = fn -> :mnesia.wait_for_tables([:block_chain], 1000) end
# t1 = fn -> :mnesia.schema(:block_chain) end
# IO.inspect t1.()


# block = %{
#   index: 0,
#   previous_hash: "0",
#   timestamp: :os.system_time(:seconds),
#   data: "foofizzbazz",
#   hash: :crypto.hash(:sha256, "cool") |> Base.encode64
# }
# t1 = fn -> :mnesia.write({:block_chain,
#   block.index,
#   block.previous_hash,
#   block.timestamp,
#   block.data,
#   block.hash}) end



t1 = fn ->
  :ok = :mnesia.wait_for_tables([:block_chain], 5000)

  r1 = :mnesia.read({:block_chain, 1})

  r2 = :mnesia.match_object({:block_chain, 1, :_, :_, :_, :_})

  r3 = :mnesia.select(:block_chain, [{{:block_chain, :"$1", :"$2", :"$3", :"$4", :"$5"}, [{:>, :"$1", 0}], [:"$$"]}])

  r4 = :mnesia.first(:block_chain)
  r5 = :mnesia.last(:block_chain)
  r6 = :mnesia.next(:block_chain, 0)
  r7 = :mnesia.prev(:block_chain, 1)
  r8 = :mnesia.all_keys(:block_chain)

  [r1, r2, r3, r4, r5, r6, r7, r8]
end

result1 = :mnesia.transaction(t1)
IO.inspect result1



# t2 = fn ->
#   :mnesia.add_table_index(:block_chain, :timestamp)
# end
# IO.inspect t2.()
