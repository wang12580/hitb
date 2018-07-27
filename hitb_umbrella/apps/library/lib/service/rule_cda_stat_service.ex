defmodule Library.RuleCdaStatService do
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Library.RuleSymptom, as: HitbRuleSymptom
  def symptom_serach(symptom) do
    result = Enum.map(Map.values(symptom), fn x ->
      res = Repo.all(from p in HitbRuleSymptom, where: p.symptom == ^x, select: p.pharmacy)
      if res == [] do
        res
      else
        hd(res)
      end
    end)
    Enum.uniq(Enum.concat(result))
  end
end
