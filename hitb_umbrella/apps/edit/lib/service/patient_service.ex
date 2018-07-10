defmodule Edit.PatientService do
  # import Ecto
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Edit.Cda
  alias Hitb.Edit.Patient
#   alias Hitb.Edit.Cda

  def patient_list(info) do
    info = Map.keys(info)
        |>Enum.map(fn x ->
            case x do
              "姓名" ->
                [:name, Map.get(info, x)]
              "性别" ->
                [:gender, Map.get(info, x)]
              "年龄" ->
                [:age, Map.get(info, x)]
              "民族" ->
                [:nationality, Map.get(info, x)]
              "婚姻状况" ->
                [:marriage, Map.get(info, x)]
              "出生地" ->
                [:native_place, Map.get(info, x)]
              "职业" ->
                [:occupation, Map.get(info, x)]
              _ -> []
            end
          end)
        |>Enum.reject(fn x -> x == nil or x == [] end)
    query = from(p in Patient)
    Enum.reduce(info, query, fn x, acc ->
      [key, value] = x
      acc
      |>where([p], field(p, ^key) == ^value)
    end)
    |>Repo.all
    |>Enum.map(fn x ->
        Enum.map(x.patient_id, fn id ->
          Repo.all(from p in Cda, where: p.patient_id == ^id)
        end)
      end)
    |>List.flatten
    |>Enum.map(fn x -> x.content end)
  end

  def patient_insert(content, usernames, patient_ids) do
    b =
      cond do
        String.contains? content, "," -> String.split(content, ",")
        true -> []
      end
    maps =
      Enum.reduce(b, %{}, fn x, acc ->
        [hd | all] = String.split(x, " ")
        all = if(all == [])do ["-"] else all end
        case hd do
          "姓名" ->
              Map.put(acc, :name, List.to_string(all))
          "性别" ->
              Map.put(acc, :gender, List.to_string(all))
          "年龄" ->
              Map.put(acc, :age, List.to_string(all))
          "民族" ->
              Map.put(acc, :nationality, List.to_string(all))
          "婚姻状况" ->
              Map.put(acc, :marriage, List.to_string(all))
          "出生地" ->
              Map.put(acc, :native_place, List.to_string(all))
          "职业" ->
              Map.put(acc, :occupation, List.to_string(all))
          _ -> acc
        end
      end)
    maps = Map.merge(%{:name => "-", :gender => "-", :age => "-", :nationality => "-", :marriage => "-", :native_place => "-", :occupation => "-"}, maps)
    patient = Repo.get_by(Patient, name: maps.name, gender: maps.gender, age: maps.age, nationality: maps.nationality, marriage: maps.marriage, native_place: maps.native_place, occupation: maps.occupation , username: usernames)
    if (patient) do
      patient
      |>Patient.changeset(%{patient_id: patient.patient_id ++ [patient_ids]})
      |>Repo.update
    else
      mapa = Map.merge(maps, %{username: usernames, patient_id: [patient_ids]})
      %Patient{}
      |> Patient.changeset(mapa)
      |> Repo.insert()
    end
    %{success: true, info: "新建成功"}
  end

end
