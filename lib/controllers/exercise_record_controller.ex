defmodule Tokyo.Controller.ExerciseRecord do
  alias Tokyo.Service.ExerciseRecord, as: ExRecService
  alias Tokyo.Model.ExerciseRecord, as: ExRecModel
  alias Tokyo.Model.ExerciseSet, as: ExSetModel

  def get_exercise_records(conn, user_id) do
    
  end

  def get_exercise_record(user_id, ex_rec_id) do
    
  end

  def save(conn, user_id) do

    ex_rec = conn.body_params

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
      [] -> ExRecService.save(ex_rec, user_id)
      _ -> {:validation_errors, errors}
    end
  end

end
