defmodule Hitbserver.File do
  #对写入文件的处理
  def write(file_path, file_name, str)do
    #临时文件是否存在
    unless(File.exists?(file_path))do
      File.mkdir(file_path)
    end
    #写文件
    {:ok, file} = File.open file_path <> file_name, [:write]
    IO.binwrite file, str
    File.close file
    #返回路径
    "http://139.129.165.56/download/" <> file_name
  end

  #对上传文件的处理
  def upload_file(file_path, conn_file) do
    %{:path => tmp_path, :filename => file_name, :content_type => content_type} = conn_file
    file_name = Hitbserver.Time.stime_number() <> "_" <> file_name
    #临时文件是否存在
    if(File.exists?(tmp_path))do
      #下载目录是否存在,不存在创建,存在直接复制临时文件到下载目录
      case File.exists?(file_path) do
        true ->
          File.cp(tmp_path, file_path <> file_name)
        false ->
          File.mkdir(file_path)
          File.cp(tmp_path, file_path <> file_name)
      end
    end
    #读取文件信息
    {:ok, file_info}  = :file.read_file_info(file_path <> file_name)
    [_, file_size, _, access, atime, mtime, ctime, _, _, _, _, _, _, _] = file_info
    #识别文件大小
    file_size =
      cond do
        file_size < 1024 -> to_string(file_size) <> "B"
        file_size > 1024 and file_size < 1048576 -> to_string(Float.round((file_size/1024), 2)) <> "KB"
        file_size > 1048576 and file_size < 1073741824 -> to_string(Float.round((file_size/1048576), 2)) <> "MB"
        true -> to_string(Float.round((file_size/1073741824), 2)) <> "GB"
      end
    %{path: "#{file_path}#{file_name}", #文件存放路径
      file_name: file_name, #文件名
      file_size: file_size, #文件大小
      file_type: content_type, #文件类型
      access: access, #文件权限
      atime: Hitbserver.Time.ttime_to_stime(atime), #最后一次读取时间
      mtime: Hitbserver.Time.ttime_to_stime(mtime), #最后一次修改时间
      ctime: Hitbserver.Time.ttime_to_stime(ctime)} #创建时间
  end

  def check(file_path) do
    #解json串
    {:ok, str} = File.read(file_path)
    cond do
      String.contains? file_path, ".csv" ->
        #从文件str切行
        str = String.split(str, "\n") -- [""]
        #取得第一行作为key
        key = List.first(str)
        key = Regex.replace(~r/\"/, key, "")
        key = String.split(key, ",")
        #把key从数组删除掉
        str = List.delete_at(str, 0)
        #取值
        Enum.map(str, fn x ->
          #去除多余的引号
          x = Regex.replace(~r/\"/, x, "")
          #得到每一行每一列的值
          x = String.split(x, ",")
          #取值
          x = Enum.reduce(0..length(key)-1, %{}, fn index, acc ->
            k = Enum.at(key, index)
            val =
              case k do
                "diags_code" -> String.split(Enum.at(x, index), "&")
                "opers_code" -> String.split(Enum.at(x, index), "&")
                _ -> Enum.at(x, index)
              end
            Map.put(acc, k, val)
          end)
          #取得错误
          error = Library.Wt4.changeset(%Library.Wt4{}, x).errors
            |>Enum.map(fn error -> hd(Tuple.to_list(error)) end)
            |>Enum.map(fn x -> to_string(x) end)
          Map.put(x, "error", error)
        end)
      String.contains? file_path, ".json" ->
        Enum.map(String.split(str, "\n") -- [""], fn x ->
          case JSON.decode(x) do
            {:ok, json} ->
              json = Map.merge(json, %{"adrg" => String.slice(json["drg"], 0, 3), "mdc" => String.at(json["drg"], 0), "department" => to_string(json["department"]), "org" => to_string(json["org"]), "org_name" => "东华万兴测试"})
              error = Library.Wt4.changeset(%Library.Wt4{}, json).errors
                |>Enum.map(fn error -> hd(Tuple.to_list(error)) end)
                |>Enum.map(fn x -> to_string(x) end)
              Map.put(json, "error", error)
            _ ->
              []
          end
        end)
    end
  end
end
