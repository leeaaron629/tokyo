defmodule Tokyo.Service.ExerciseRecord do
  require Ecto.Query
  import Ecto.Query
  alias Tokyo.Db.ExerciseRecord, as: ExRecDb
  alias Tokyo.Service.ExerciseSet, as: ExSetService

  def get_all(from, to, user_id) do
    IO.puts "Fetching exercises records from #{from} - #{to} for #{user_id}"

    from(
      er in Tokyo.Db.ExerciseRecord,
      where: er.created_date >= ^from and er.created_date < ^to and er.user_id == ^user_id,
      order_by: [desc: er.created_date]
    )
      |> Tokyo.Repo.all
      |> Enum.map(fn record -> to_model(record) end)
      |> Enum.map(
        fn record -> 
          Map.put(record, "sets", ExSetService.get_all(record["exerciseRecId"])) 
        end
      )

  end

  def get_one(ex_rec_id) do
    IO.puts "Fetching an exercise record with #{ex_rec_id}"

    ex_rec = Tokyo.Db.ExerciseRecord
      |> where(ex_rec_id: ^ex_rec_id)
      |> Tokyo.Repo.one
      |> to_model

      cond do
        ex_rec == %{} -> nil
        ex_rec == nil -> nil
        true -> Map.put(ex_rec, "sets", ExSetService.get_all(ex_rec_id))       
      end
  end

  def save(ex_rec, user_id) do
    IO.puts "Saving exercise record for #{user_id} #{inspect ex_rec}"

    ex_rec_to_save = %{
      user_id: user_id,
      ex_rec_id: ex_rec["exerciseRecId"],
      ex_id: ex_rec["exerciseId"],
      ex_name: ex_rec["exerciseName"],
      workout_id: ex_rec["workoutId"],
      created_date: ex_rec["createdDate"],
    }

    saved_ex_rec_response = case ex_rec["exerciseRecId"] do
      nil ->
        ex_rec_to_save 
          |> Map.put(:ex_rec_id, Ecto.UUID.generate)
          |> create
      _ ->
        ex_rec_to_save
          |> Map.put(:ex_rec_id, ex_rec["exerciseRecId"])
          |> update
    end

    saved_ex_sets_response = case saved_ex_rec_response do
      {:ok, saved_ex_rec} -> 
        update_ex_sets(ex_rec["sets"], saved_ex_rec["exerciseRecId"])
      {:error, msg} -> {:error, msg}
    end

    case saved_ex_sets_response do
      {:ok, saved_ex_sets} ->
        {:ok, saved_ex_rec} = saved_ex_rec_response
        IO.puts "saved_ex_rec_from response: #{inspect saved_ex_rec}"
        saved_ex_rec
          |> Map.put("sets", saved_ex_sets)
      {:error, msg} -> {:error, msg}
    end
  end

  defp update_ex_sets(sets_to_save, ex_rec_id) do
    # Delete all exercise sets of this ex_rec
    ExSetService.delete_ex_sets(ex_rec_id)    
    IO.puts "Saving exercise sets #{inspect sets_to_save} with #{ex_rec_id}..."
    ExSetService.save_all(sets_to_save, ex_rec_id)
  end

  # TODO - Check if it's possible to combine create & update into insert_or_update
  def create(ex_rec) do
    IO.puts "Creating exercise record #{inspect ex_rec}"
    changeset = %Tokyo.Db.ExerciseRecord{}
      |> ExRecDb.changeset(ex_rec)
      |> IO.inspect

    result = cond do
      changeset.errors != [] -> {:error, changeset.errors}
      changeset.errors == [] -> Tokyo.Repo.insert_or_update(changeset)
    end

    case result do 
      {:ok, created_ex_rec} -> {:ok, to_model(created_ex_rec)}
      {:error, error} -> {:error, error}
    end
  end

  def update(ex_rec) do

    IO.puts "Updating exercise record #{inspect ex_rec}"

    user_id = ex_rec[:user_id]
    ex_rec_id = ex_rec[:ex_rec_id]

    IO.puts "user_id: #{user_id} ex_rec_id: #{ex_rec_id}"

    current = Tokyo.Db.ExerciseRecord
      |> where(ex_rec_id: ^ex_rec_id)
      |> Tokyo.Repo.one

    IO.puts "Current: #{inspect current}"

    case current do
      nil -> {:error, %{"message" => "Not Found"}}
      current ->
        Tokyo.Db.ExerciseRecord.changeset(current, ex_rec)
          |> Tokyo.Repo.update
          |> case do
            {:ok, updated_ex_rec} -> {:ok, to_model(updated_ex_rec)}
            {:error, changeset} -> IO.puts "Error updated exercise record: #{inspect changeset}"    
          end
    end
  end

  def delete_ex_rec(ex_rec_id) do
    IO.puts "Deleting exercise record #{inspect ex_rec_id}..."
    ExSetService.delete_ex_sets(ex_rec_id)
      |> case do
        {:ok, _} -> delete(ex_rec_id)
        {:error, errors} -> {:error, errors}
      end
  end

  defp delete(ex_rec_id) do
    Tokyo.Db.ExerciseRecord
      |> where(ex_rec_id: ^ex_rec_id)
      |> Tokyo.Repo.one
      |> IO.inspect
      |> Tokyo.Repo.delete
      |> case do
        {:ok, ex_rec} -> IO.puts "Deleted #{inspect ex_rec}"
        {:error, changeset} -> IO.puts "Error occured during deletion: #{inspect changeset}"
      end
  end

  defp reps_and_weights_from(sets) do
    case sets do
      nil -> [[], []]
      _ -> 
          reps = sets |> Enum.map(fn set -> set["reps"] end)
          weights = sets |> Enum.map(fn set -> set["weight"] end)
          [reps, weights]
    end
  end

  defp sets_from(reps, weights) do
    Enum.zip(reps, weights)
    |> Enum.map(fn {reps, weight} -> %{"reps" => reps, "weight" => weight} end)
  end

  defp to_model(nil), do: %{}
  defp to_model(exRecDb) do
    %{
      "userId" => exRecDb.user_id,
      "exerciseRecId" => exRecDb.ex_rec_id,
      "exerciseId" => exRecDb.ex_id,
      "exerciseName" => exRecDb.ex_name,
      "workoutId" => exRecDb.workout_id,
      "createdDate" => exRecDb.created_date
    }
  end

end
