defmodule Tokyo.Controller.ExerciseRecord do
  alias Tokyo.Service.ExerciseRecord, as: ExRecService
  alias Tokyo.Model.ExerciseRecord, as: ExRecModel
  alias Tokyo.Model.ExerciseSet, as: ExSetModel

  def save_ex_rec(ex_rec, user_id) do

    ex_rec_errors = 
      %ExRecModel{} 
      |> ExRecModel.changeset(ex_rec)
      |> Map.get(:errors)
    
    ex_set_errors = case ex_rec["sets"] do
      sets -> 
        sets
          |> Enum.map(fn set -> %ExSetModel{} |> ExSetModel.changeset(set) end)
          |> Enum.map(fn set_changeset -> set_changeset.errors end)
      
      nil -> []
    end

    errors = ex_rec_errors ++ ex_set_errors

    case List.flatten(errors) do
      [] -> ExRecService.save_ex_rec(ex_rec, user_id)
      _ -> errors
    end

  end

  defp extract_reps_and_weights(sets) do
    reps = sets |> Enum.map(fn sets -> Map.get(sets, "reps") end)
    weights = sets |> Enum.map(fn sets -> Map.get(sets, "weight") end)
    [reps, weights]
  end
end
