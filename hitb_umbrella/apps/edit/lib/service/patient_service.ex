defmodule Edit.PatientService do
  # import Ecto
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Edit.Patient
  alias Hitb.Edit.Cda

  def patient_list(names, username) do
    keys = Map.keys(names)
    maps =
        Enum.reduce(keys, %{}, fn x, acc ->
            case x do
                "姓名" ->
                    Map.put(acc, :name, Map.get(names, x))
                "性别" ->
                    Map.put(acc, :gender, Map.get(names, x))
                "年龄" ->
                    Map.put(acc, :age, Map.get(names, x))
                "民族" ->
                    Map.put(acc, :nationality, Map.get(names, x))
                "婚姻状况" ->
                    Map.put(acc, :marriage, Map.get(names, x))
                "出生地" ->
                    Map.put(acc, :native_place, Map.get(names, x))
                "职业" ->
                    Map.put(acc, :occupation,Map.get(names, x))
                _ -> acc
            end
        end)
    maps = Map.merge(%{:name => "--", :gender => "--", :age => "--", :nationality => "--", :marriage => "--", :native_place => "--", :occupation => "--"}, maps)
    %{ :name => name, :gender => gender, :age => age, :nationality => nationality, :native_place => native_place, :occupation => occupation} = maps
    patient = Repo.all(from p in Patient, where: (p.name == ^name or p.gender == ^gender or p.age == ^age or p.nationality == ^nationality or p.native_place == ^native_place or p.occupation == ^occupation) and p.username == ^username, select: p.patient_id)
  end

  def patient_insert(content, usernames, patient_ids) do
    b = String.split(content, ",")
    maps =
        Enum.reduce(b, %{}, fn x, acc ->
            [hd | all] = String.split(x, " ")
            if (all == []) do
                all = ["--"]
            end
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
        maps = Map.merge(%{:name => "--", :gender => "--", :age => "--", :nationality => "--", :marriage => "--", :native_place => "--", :occupation => "--"}, maps)
    patient = Repo.get_by(Patient, name: maps.name, gender: maps.gender, age: maps.age, nationality: maps.nationality, marriage: maps.marriage,
    native_place: maps.native_place, occupation: maps.occupation , username: usernames)
    # patient = Repo.get_by(Patient, name: maps.name, username: usernames)
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
