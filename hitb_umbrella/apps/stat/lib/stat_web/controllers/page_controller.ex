defmodule StatWeb.PageController do
  use StatWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def test(conn, _params) do
    {:ok, sql} = File.read("/home/hitb2/git/hitbweb/plpgsql/jklf/getstat.sql")
    [sql1, sql2] = String.split(sql, "CASE page_type")
    sql2 =  Enum.map(String.split(sql2, "\n"), fn x ->
        if(String.contains? x, "res := array[[")do
          [space, array] = String.split(x, "res := array[[")
          arrays = String.split(array, "],[")
          [a1, a2, a3] = arrays
          if (String.contains? a2, "'org','time','num_num'") do
            a2 = String.split(a2, ",")|>Enum.reject(fn x -> x == "'num_sum'" or x == "'num_num'" end)
            a2 = a2 ++ ["'num_sum'"]
            a1 = Enum.map(1..length(a2), fn x -> "i2" end)|>Enum.join(",")
            a2 = a2|>Enum.join(",")
          end

          if (String.contains? a3, "'病历数',") do
            a3 = String.split(a3, ",")|>Enum.reject(fn x -> x == "'病历数'" end)|>Enum.join(",")
          end
          # a1 = Enum.map(1..length(a2), fn x -> "i2" end)|>Enum.join(",")
          # a2 = a2|>Enum.join(",")
          # a3 = a3|>Enum.join(",")
          x = "#{space}res := array[[#{[a1, a2, a3]|>Enum.join("],[")}"
          # IO.inspect x
        end

        # if (res := res || array[[r.org,r.time,cast(r.num_num as text))
        x
      end)
      |>Enum.join("\n")
    sql = "#{sql1}CASE page_type#{sql2}"
    {:ok, file} = File.open "/home/hitb2/a.sql", [:write]
    IO.binwrite file, sql
    json conn, %{}
  end
end
