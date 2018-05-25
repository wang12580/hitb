defmodule Hitb.Time do

  #本地时间国标string
  def stime_local() do
    time = :calendar.local_time()
    {year, month, day, hour, minute, second} = gb_time(time)
    to_string(year) <> "-" <> to_string(month) <> "-" <> to_string(day) <> " " <> to_string(hour) <> ":" <> to_string(minute) <> ":" <> to_string(second)
  end

  #当前日期字符串string
  def sdata_date() do
    {{year, month, day}, _} = :calendar.local_time()
    to_string(year) <> "-" <> to_string(month) <> "-" <> to_string(day)
  end

  #
  def standard_time() do
    time = :calendar.local_time()
    {year, month, day, hour, minute, second} = gb_time(time)
    "#{to_string(year)}年#{to_string(month)}月#{to_string(day)}日 #{to_string(hour)}:#{to_string(minute)}:#{to_string(second)}"
  end

  #当前日期字符串string
  def sdata_date2() do
    time = :calendar.local_time()
    {year, month, day, _, _, _} = gb_time(time)
    to_string(year) <> to_string(month) <> to_string(day)
  end

  #昨天日期字符串string
  def sdate_yes() do
    {{year, month, day}, _} = :calendar.local_time()
    days = :calendar.date_to_gregorian_days({year, month, day}) - 1
    {year, month, day} = :calendar.gregorian_days_to_date(days)
    to_string(year) <> "-" <> to_string(month) <> "-" <> to_string(day)
  end

  #数据库时间转国标string
  def stime_ecto(time) do
    {:ok, time} =  Ecto.DateTime.cast(time)
    time = :calendar.universal_time_to_local_time(Ecto.DateTime.to_erl(time))
    {year, month, day, hour, minute, second} = gb_time(time)
    to_string(year) <> "-" <> to_string(month) <> "-" <> to_string(day) <> " " <> to_string(hour) <> ":" <> to_string(minute) <> ":" <> to_string(second)
  end

  #数据库日期转国标string
  def sdate_ecto(time) do
    {:ok, time} =  Ecto.DateTime.cast(time)
    time = :calendar.universal_time_to_local_time(Ecto.DateTime.to_erl(time))
    {year, month, day, _, _, _} = gb_time(time)
    to_string(year) <> "-" <> to_string(month) <> "-" <> to_string(day)
  end

  #当前时间数字连接string
  def stime_number() do
    time = :calendar.local_time()
    {year, month, day, hour, minute, second} = gb_time(time)
    to_string(year) <> to_string(month) <> to_string(day) <> to_string(hour) <> to_string(minute) <> to_string(second)
  end

  #当前时间到小时数字连接string
  def stimehour_number() do
    time = :calendar.local_time()
    {year, month, day, hour, _minute, _second} = gb_time(time)
    to_string(year) <> to_string(month) <> to_string(day) <> to_string(hour)
  end

  #utc时间
  # def stime_utc() do
  #   time =  :calendar.local_time_to_universal_time(:calendar.local_time())
  #   {year, month, day, hour, minute, second} = gb_time(time)
  #   to_string(year) <> "-" <> to_string(month) <> "-" <> to_string(day) <> " " <> to_string(hour) <> ":" <> to_string(minute) <> ":" <> to_string(second)
  # end

  #字符串时间转tuple
  def stime_to_ttime(time) do
    [date|[time]] = String.split(time, " ")
    [year|[month|[day]]] = String.split(date, "-")
    [hour|[min|[sed]]] = String.split(time, ":")
    {{String.to_integer(year), String.to_integer(month), String.to_integer(day)}, {String.to_integer(hour), String.to_integer(min), String.to_integer(sed)}}
  end

  #tuple时间转字符串
  def ttime_to_stime(time) do
    {year, month, day, hour, minute, second} = gb_time(time)
    to_string(year) <> "-" <> to_string(month) <> "-" <> to_string(day) <> " " <> to_string(hour) <> ":" <> to_string(minute) <> ":" <> to_string(second)
  end

  #当前字符串时间转数据库查询字符串时间
  # def stime_to_pstime(time) do
  #   time = :calendar.local_time_to_universal_time(stime_to_ttime(time))
  #   {year, month, day, hour, minute, second} = gb_time(time)
  #   to_string(year) <> "-" <> to_string(month) <> "-" <> to_string(day) <> " " <> to_string(hour) <> ":" <> to_string(minute) <> ":" <> to_string(second)
  # end

  #当前日期所在周的周一和周日的日期tuple
  def tweek() do
    {{year, month, day}, _} = :calendar.local_time()
    total_day = :calendar.date_to_gregorian_days(year, month, day)
    what_day_is_today = :calendar.day_of_the_week(year, month, day)
    [this_week_monday|[this_week_sunday]] =
    case what_day_is_today do
      1 -> [total_day - 0, total_day + 6]
      2 -> [total_day - 1, total_day + 5]
      3 -> [total_day - 2, total_day + 4]
      4 -> [total_day - 3, total_day + 3]
      5 -> [total_day - 4, total_day + 2]
      6 -> [total_day - 5, total_day + 1]
      7 -> [total_day - 6, total_day + 0]
    end
    monday = :calendar.gregorian_days_to_date(this_week_monday)
    sunday = :calendar.gregorian_days_to_date(this_week_sunday)
    {monday, sunday}
  end

  #当前日期所在周的周一和周日的日期string
  def sweek() do
    {{year, month, day}, _} = :calendar.local_time()
    total_day = :calendar.date_to_gregorian_days(year, month, day)
    what_day_is_today = :calendar.day_of_the_week(year, month, day)
    [this_week_monday|[this_week_sunday]] =
    case what_day_is_today do
      1 -> [total_day - 0, total_day + 6]
      2 -> [total_day - 1, total_day + 5]
      3 -> [total_day - 2, total_day + 4]
      4 -> [total_day - 3, total_day + 3]
      5 -> [total_day - 4, total_day + 2]
      6 -> [total_day - 5, total_day + 1]
      7 -> [total_day - 6, total_day + 0]
    end
    {this_week_monday_year, this_week_monday_month, this_week_monday_day} = :calendar.gregorian_days_to_date(this_week_monday)
    {this_week_sunday_year, this_week_sunday_month, this_week_sunday_day} = :calendar.gregorian_days_to_date(this_week_sunday)
    this_week_monday_year =
      if(this_week_monday_year < 10)do
        "0" <> to_string(this_week_monday_year)
      else
        to_string(this_week_monday_year)
      end
    this_week_monday_month =
      if(this_week_monday_month < 10)do
        "0" <> to_string(this_week_monday_month)
      else
        to_string(this_week_monday_month)
      end
    this_week_monday_day =
      if(this_week_monday_day < 10)do
        "0" <> to_string(this_week_monday_day)
      else
        to_string(this_week_monday_day)
      end
    this_week_sunday_year =
      if(this_week_sunday_year < 10)do
        "0" <> to_string(this_week_sunday_year)
      else
        to_string(this_week_sunday_year)
      end
    this_week_sunday_month =
      if(this_week_sunday_month < 10)do
        "0" <> to_string(this_week_sunday_month)
      else
        to_string(this_week_sunday_month)
      end
    this_week_sunday_day =
      if(this_week_sunday_day < 10)do
        "0" <> to_string(this_week_sunday_day)
      else
        to_string(this_week_sunday_day)
      end
    this_week_monday = to_string(this_week_monday_year) <> "-" <> to_string(this_week_monday_month) <> "-" <> to_string(this_week_monday_day)
    this_week_sunday = to_string(this_week_sunday_year) <> "-" <> to_string(this_week_sunday_month) <> "-" <> to_string(this_week_sunday_day)
    [this_week_monday, this_week_sunday]
  end

  #当前月份string
  def smonth() do
    {{year, month, _}, _} = :calendar.local_time()
    to_string(year) <> "-" <> to_string(month)
  end

  #转换为国标时间格式
  defp gb_time(time) do
    {{year, month, day},{hour, minute, second}} = time
    month =
      case month < 10 do
        true -> "0" <> to_string(month)
        false -> to_string(month)
      end
    day =
      case day < 10 do
        true -> "0" <> to_string(day)
        false -> to_string(day)
      end
    hour =
      case hour < 10 do
        true -> "0" <> to_string(hour)
        false -> to_string(hour)
      end
    minute =
      case minute < 10 do
        true -> "0" <> to_string(minute)
        false -> to_string(minute)
      end
    second =
      case second < 10 do
        true -> "0" <> to_string(second)
        false -> to_string(second)
      end
    {year, month, day, hour, minute, second}
  end
  #两个时间差值
  def time_difference(time1, time2) do
    time1 = stime_to_ttime(time1)
    time2 = stime_to_ttime(time2)
    {_, {hour, minute, second}} = :calendar.time_difference(time1, time2)
    hour*3600 + minute*60 + second
  end
end
