IO.puts("======mnesia test=====")
:mnesia.start()
# :mnesia.info()

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

# t1 = fn -> :mnesia.table(:block_chain) end
# t1 = fn -> :mnesia.table_info(:block_chain, :all) end

# t1 = fn -> :mnesia.wait_for_tables([:block_chain], 1000) end
# t1 = fn -> :mnesia.schema(:block_chain) end



IO.inspect t1.()
# result = :mnesia.transaction(t1)
# IO.inspect result
