:mnesia.create_schema([node()])

Node.self

:mnesia.start()

:mnesia.create_table(:person, [attributes: [:id, :name, :job]])

:observer.start

:mnesia.transaction(fn -> :mnesia.write({:person, 4, "Marge Simpson", "home maker"}) end)

:mnesia.add_table_index(:person, :job)

:mnesia.transaction(fn -> :mnesia.index_read(:person, "home maker", :job) end)
