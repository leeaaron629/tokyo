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
      ex_id: ex_rec["exerciseId"],
      ex_name: ex_rec["exerciseName"],
      workout_id: ex_rec["workoutId"],
      created_date: ex_rec["createdDate"],
    }

    saved_ex_rec = case ex_rec["exerciseRecId"] do
      nil ->
        ex_rec_to_save 
          |> Map.put(:ex_rec_id, Ecto.UUID.generate)
          |> create
      _ ->
        ex_rec_to_save
          |> Map.put(:ex_rec_id, ex_rec["exerciseRecId"])
          |> update
    end

    IO.puts "Result from #{inspect ex_rec}"
    ex_rec_id = saved_ex_rec["exerciseRecId"]

    # Delete all exercise sets of this ex_rec
    ExSetService.delete_ex_sets(ex_rec_id)    

    IO.puts "Saving exercise sets #{inspect ex_rec["sets"]} with #{ex_rec_id}..."
    saved_sets = ExSetService.save_all(ex_rec["sets"], ex_rec_id)
      |> IO.inspect
      |> case do
        {:ok, sets} -> sets
        {:error, errors} -> IO.puts "Error saving exercise sets: #{errors}" 
      end
     
    saved_ex_rec
      |> Map.put("sets", saved_sets)
      |> IO.inspect

  end

  # TODO - Check if it's possible to combine create & update into insert_or_update
  def create(ex_rec) do
    IO.puts "Creating exercise record #{inspect ex_rec}"
    %Tokyo.Db.ExerciseRecord{}
      |> ExRecDb.changeset(ex_rec)
      |> IO.inspect
      |> Tokyo.Repo.insert_or_update
      |> case do
        {:ok, created_ex_rec} -> to_model(created_ex_rec)
        {:error, changeset} -> IO.puts "Error has occured: #{inspect changeset}"
      end
  end

  def update(ex_rec) do

    IO.puts "Updating exercise record #{inspect ex_rec}"

    user_id = ex_rec[:user_id]
    ex_rec_id = ex_rec[:ex_rec_id]

    IO.puts "user_id: #{user_id} ex_rec_id: #{ex_rec_id}"

    current = Tokyo.Db.ExerciseRecord
      |> where(user_id: ^user_id, ex_rec_id: ^ex_rec_id)
      |> Tokyo.Repo.one

    IO.puts "Current: #{inspect current}"

    Tokyo.Db.ExerciseRecord.changeset(current, ex_rec)
      |> Tokyo.Repo.update
      |> case do
          {:ok, updated_ex_rec} -> to_model(updated_ex_rec)
          {:error, changeset} -> IO.puts "Error updated exercise record: #{inspect changeset}"  
      end

  end

  def delete(ex_rec_id) do
    IO.puts "Deleting exercise record #{inspect ex_rec_id}..."
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
