defmodule Block.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      supervisor(Block.Repo, []),
      Block.S1,
      Block.S2
    ]
    opts = [strategy: :one_for_one, name: Block.Supervisor]
    supervisor = Supervisor.start_link(children, opts)
    initialize_datastore()
    supervisor
  end

  def initialize_datastore() do
    :ets.new(:peers, [:set, :public, :named_table])
    :ets.new(:latest_block, [:set, :public, :named_table])
    generate_initial_block()
  end

  def generate_initial_block() do
    if(Block.BlockRepository.get_all_blocks == [])do
      secret = "someone manual strong movie roof episode eight spatial brown soldier soup motor"
      init_block = %{
        index: 0,
        previous_hash: "0",
        timestamp: :os.system_time(:seconds),
        data: "foofizzbazz",
        hash: :crypto.hash(:sha256, "cool") |> Base.encode64 |> regex,
        generateAdress: :crypto.hash(:sha256, "#{secret}")|> Base.encode64 |> regex
      }
      Block.BlockRepository.insert_block(init_block)
    end
  end

  defp regex(s) do
    [~r/\+/, ~r/ /, ~r/\=/, ~r/\%/, ~r/\//, ~r/\#/, ~r/\$/, ~r/\~/, ~r/\'/, ~r/\@/, ~r/\*/, ~r/\-/]
    |> Enum.reduce(s, fn x, acc -> Regex.replace(x, acc, "") end)
  end
end
