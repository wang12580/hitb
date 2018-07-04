defmodule Stat.Task do
  use GenServer
  alias Stat.StatCdaService
  alias Hitb.Time

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: Task)
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    IO.puts "====自动执行病案搜索索引更新任务,当前时间#{Time.stime_local()}===="
    StatCdaService.comp()
    IO.puts "====更新完成,24小时后执行下次更新===="
    Process.send_after(self(), :work, 24 * 60 * 60 * 1000) # In 24 hours
  end

end
