defmodule Tokyo.Controller.ExerciseRecord do
  alias Tokyo.Service.ExerciseRecord, as: ExRecService
  alias Tokyo.Model.ExerciseRecord, as: ExRecModel
  alias Tokyo.Model.ExerciseSet, as: ExSetModel

  @beg_of_time ~U[1900-01-01 00:00:00Z]

  def get_all(conn, user_id) do
  
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
      [{:ok, from, _}, {:ok, to, _}] -> ExRecService.get_all(from, to, user_id)
    end

  end

  def get_one(ex_rec_id) do
    ExRecService.get_one(ex_rec_id)
  end

  # TODO - Combine the two save methods below
  def save(conn, user_id, ex_rec_id) do
    ex_rec = conn.body_params
      |> Map.put("exerciseRecId", ex_rec_id)
    
    case validate(ex_rec) do
      [] -> ExRecService.save(ex_rec, user_id)
      errors -> {:validation_errors, errors}
    end
  end

  def save(conn, user_id) do 
    ex_rec = conn.body_params
    
    case validate(ex_rec) do
      [] -> ExRecService.save(ex_rec, user_id)
      errors -> {:validation_errors, errors}
    end
  end

  def delete(_conn, ex_rec_id) do
    ExRecService.delete_ex_rec(ex_rec_id)
  end

  defp validate(ex_rec) do
    # Validate the exercise record 
    ex_rec_errors = 
      %ExRecModel{} 
      |> ExRecModel.changeset(ex_rec)
      |> Map.get(:errors)
    # Validate the exercise sets
    ex_set_errors = case ex_rec["sets"] do
      sets -> 
        sets
          |> Enum.map(fn set -> %ExSetModel{} |> ExSetModel.changeset(set) end)
          |> Enum.map(fn set_changeset -> set_changeset.errors end)
      nil -> []
    end
    # Return errors if there are any
    ex_rec_errors ++ ex_set_errors
      |> List.flatten
      |> IO.inspect
  end

  def to_datetime(iso8601_datetime) do
    case DateTime.from_iso8601(iso8601_datetime) do
      {:ok, utc_datetime, _offset} -> utc_datetime
      {:error, error} -> error
    end
  end

end
