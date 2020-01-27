defmodule Tokyo.Service.ExerciseRecord do
  require Ecto.Query
  import Ecto.Query
  alias Tokyo.Db.ExerciseRecord, as: ExRecDb

  def fetch_exercise_records(from, to, user_id) do

    from(
      er in Tokyo.Db.ExerciseRecord,
      where: er.created_date >= ^from and er.created_date < ^to
    )
      |> Tokyo.Repo.all
      |> Enum.map(fn record -> exRecDbToModel(record) end)

  end

  def fetch_exercise_records_by_user_id(user_id) do
    IO.puts("Fetching exercises for #{user_id}")

    case exercise_records = ExerciseRecord.get_exercise_records(user_id) do
      nil -> []
      _ -> Map.values(exercise_records)
    end
  end

  def fetch_an_exercise_record(user_id, ex_rec_id) do
    IO.puts("Fetching exercise record for #{user_id} [#{ex_rec_id}]")

    case exercise_records = ExerciseRecord.get_exercise_records(user_id) do
      nil -> %{}
      _ -> exercise_records
    end
    |> Map.get(ex_rec_id, nil)
  end

  def save(ex_rec, user_id) do
    IO.puts "Saving exercise record for #{user_id}"

    [reps, weights] = reps_and_weights_from(ex_rec["sets"])

    ex_rec_to_save = %{
      user_id: user_id,
      ex_rec_id: Ecto.UUID.generate,
      ex_id: ex_rec["exerciseId"],
      ex_name: ex_rec["exerciseName"],
      workout_id: ex_rec["workoutId"],
      reps: reps,
      weights: weights,
      created_date: ex_rec["createdDate"],
    }

    IO.inspect ex_rec_to_save

    %Tokyo.Db.ExerciseRecord{}
      |> ExRecDb.changeset(ex_rec_to_save)
      |> Tokyo.Repo.insert
      |> case do
        {:ok, saved_ex_rec} -> exRecDbToModel(saved_ex_rec)
        {:error, changeset} -> IO.puts "Error has occured: #{inspect changeset}"
      end


  end

  def delete_exercise_rec(id, user_id) do
    IO.puts("Deleting exercise record #{inspect(id)} from #{inspect(user_id)}")
    ExerciseRecord.remove_exercise_records(id, user_id)
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
