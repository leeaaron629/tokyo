defmodule Tokyo.Service.ExerciseRecord do
  require Ecto.Query
  import Ecto.Query
  alias Tokyo.Db.ExerciseRecord, as: ExRecDb

  def get_all(from, to, user_id) do
    IO.puts "Fetching exercises records from #{from} - #{to} for #{user_id}"

    from(
      er in Tokyo.Db.ExerciseRecord,
      where: er.created_date >= ^from and er.created_date < ^to
    )
      |> Tokyo.Repo.all
      |> Enum.map(fn record -> exRecDbToModel(record) end)

  end

  def get_one(user_id, ex_rec_id) do
    IO.puts "Fetching an exercise record for #{user_id} [#{ex_rec_id}]"

    Tokyo.Db.ExerciseRecord
      |> where(user_id: ^user_id, ex_rec_id: ^ex_rec_id)
      |> Tokyo.Repo.one
      |> exRecDbToModel

  end

  def save(ex_rec, user_id) do
    IO.puts "Saving exercise record for #{user_id}"

    [reps, weights] = reps_and_weights_from(ex_rec["sets"])

    ex_rec_to_save = %{
      user_id: user_id,
      ex_id: ex_rec["exerciseId"],
      ex_name: ex_rec["exerciseName"],
      workout_id: ex_rec["workoutId"],
      reps: reps,
      weights: weights,
      created_date: ex_rec["createdDate"],
    }

    ex_rec_id = case ex_rec["exerciseRecId"] do
      nil ->
        ex_rec_to_save 
          |> Map.put(:ex_rec_id, Ecto.UUID.generate)
          |> create

      _ ->
        ex_rec_to_save
          |> Map.put(:ex_rec_id, ex_rec["exerciseRecId"])
          |> update
    end

  end

  def create(ex_rec) do

    IO.puts "Creating exercise record #{inspect ex_rec}"

    %Tokyo.Db.ExerciseRecord{}
      |> ExRecDb.changeset(ex_rec)
      |> Tokyo.Repo.insert_or_update
      |> case do
        {:ok, created_ex_rec} -> exRecDbToModel(created_ex_rec)
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
          {:ok, updated_ex_rec} -> exRecDbToModel(updated_ex_rec)
          {:error, changeset} -> IO.puts "Error updated exercise record: #{inspect changeset}"
        end

  end

  def delete(user_id, ex_rec_id) do
    IO.puts "Deleting exercise record #{inspect ex_rec_id} from #{inspect user_id}"
    Tokyo.Db.ExerciseRecord
      |> where(user_id: ^user_id, ex_rec_id: ^ex_rec_id)
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

  defp exRecDbToModel(nil), do: %{}
  defp exRecDbToModel(exRecDb) do
    %{
      "userId" => exRecDb.user_id,
      "exerciseRecId" => exRecDb.ex_rec_id,
      "exerciseId" => exRecDb.ex_id,
      "exerciseName" => exRecDb.ex_name,
      "workoutId" => exRecDb.workout_id,
      "sets" => sets_from(exRecDb.reps, exRecDb.weights),
      "createdDate" => exRecDb.created_date
    }
  end

end
