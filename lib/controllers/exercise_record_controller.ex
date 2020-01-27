defmodule Tokyo.Controller.ExerciseRecord do
  alias Tokyo.Service.ExerciseRecord, as: ExRecService
  alias Tokyo.Model.ExerciseRecord, as: ExRecModel
  alias Tokyo.Model.ExerciseSet, as: ExSetModel

  @beg_of_time ~U[1900-01-01 00:00:00Z]

  def get_exercise_records(conn, user_id) do
  
    from = case conn.query_params["createdFrom"] do
      nil -> {:ok, @beg_of_time, 0}
      createdFrom -> DateTime.from_iso8601(createdFrom)
    end

    to = case conn.query_params["createdTo"] do
      nil -> {:ok, DateTime.utc_now, 0}
      createdTo -> DateTime.from_iso8601(createdTo)
    end

    case [from, to] do
      [{:error, errors}, {:error, errors}] -> %{"from" => errors, "to" => errors}
      [{:error, errors}, _] -> %{"to" => errors}
      [_, {:error, errors}] -> %{"from" => errors}
      [{:ok, from, _}, {:ok, to, _}] -> ExRecService.fetch_exercise_records(from, to, user_id)
    end

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

  def to_datetime(iso8601_datetime) do
    case DateTime.from_iso8601(iso8601_datetime) do
      {:ok, utc_datetime, _offset} -> utc_datetime
      {:error, error} -> error
    end
  end

end
