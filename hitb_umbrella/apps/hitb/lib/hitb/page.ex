defmodule Hitb.Page do
  #求当前页的skip值(当前页码,每页条数)
  def skip(page, num) do
    #定义每页条目数量
    cond do
      is_integer(page) -> (page-1)*num
      is_bitstring(page) -> (elem(Integer.parse(page),0)-1)*num
    end
  end

  #求分页列表(当前页码,总计条数,每页条数)
  def page_list(page, count, num) do
    #定义每页条目数量
    unless(num == 0)do
      page =
        cond do
          is_integer(page) -> page
          is_bitstring(page) -> elem(Integer.parse(page),0)
        end
      #求总页数
      page_count =  Float.ceil(count/num)
      page_count = elem(Integer.parse(to_string(page_count)), 0)
      #求分页列表(首页,末页)
      page_list1 =
        cond do
          page_count == 0 -> %{first: nil, last: nil}
          page_count < 10 -> %{first: nil, last: nil}
          page_count == 10 -> %{first: nil, last: nil}
          page - 5 <= 0 and page_count > 10 -> %{first: nil, last: %{page: to_string(page_count), num: ">>"}}
          page - 5 >= 0 and page + 5 <= page_count -> %{first: %{page: "1", num: "<<"}, last: %{page: to_string(page_count), num: ">>"}}
          page + 5 > page_count and page == page_count -> %{first: %{page: "1", num: "<<"}, last: nil}
          page + 5 > page_count -> %{first: %{page: "1", num: "<<"}, last: nil}
        end
      #求分页列表(上一页,下一页)
      page_list2 =
        cond do
          page_count == 0 -> %{up: nil, down: nil}
          page == 1 and page_count == page -> %{up: nil, down: nil}
          page == 1 -> %{up: nil, down: %{page: to_string(page + 1), num: ">"}}
          page == page_count -> %{up: %{page: to_string(page - 1), num: "<"}, down: nil}
          true -> %{up: %{page: to_string(page - 1), num: "<"}, down: %{page: to_string(page + 1), num: ">"}}
        end
      #求分页列表(分页列表,首页,末页)
      page_list3 =
        cond do
          page_count == 0 -> []
          page_count < 10 -> 1..page_count
          page_count == 10 -> 1..10
          page - 5 <= 0 and page_count > 10 -> 1..10
          page - 5 >= 0 and page + 5 <= page_count -> page - 5..page + 4
          page + 5 > page_count and page == page_count -> page_count-9..page_count
          page + 5 > page_count -> page_count-9..page_count
        end
      #完整分组列表
      %{:first => first, :last => last} = page_list1
      %{:up => up, :down => down} = page_list2
      page_list3 = Enum.map(page_list3, fn x ->
        %{page: to_string(x), num: to_string(x)}
       end)
      #整个列表
      page_list = [first] ++ [up] ++ page_list3 ++ [down] ++ [last]
      [page, Enum.reject(page_list, fn (x) -> x == nil end), page_count]
    else
      [1, [], []]
    end
  end
end
