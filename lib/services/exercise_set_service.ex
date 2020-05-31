defmodule Tokyo.Service.ExerciseSet do
  require Ecto.Query
  import Ecto.Query
  alias Tokyo.Db.ExerciseSet

  def get_all(ex_rec_id) do
    IO.puts "Getting all exercise sets for #{ex_rec_id}..."
    from(
      es in Tokyo.Db.ExerciseSet,
      where: es.ex_rec_id == ^ex_rec_id
    )
      |> Tokyo.Repo.all
      |> Enum.map(fn a_set -> to_model(a_set) end)
      |> IO.inspect
  end

  def get_one(ex_set_id) do
    IO.puts "Getting an exercise set - #{ex_set_id}..."
    
    Tokyo.Db.ExerciseSet
      |> where(ex_set_id: ^ex_set_id)
      |> Tokyo.Repo.one
      |> to_model
  end

  def save(ex_rec_id, ex_sets) do
    IO.puts "Creating exercise sets for #{inspect ex_rec_id}..."
    
    sets_to_save = Enum.map(ex_sets, 
      fn a_set -> 
        %{
          ex_set_id: Ecto.UUID.generate,
          ex_rec_id: ex_rec_id,
          reps: a_set["reps"],
          weight: a_set["weight"]
        }
      end
    )

    errors = sets_to_save 
      |> Enum.map(&validate/1)
      |> Enum.map(fn changeset -> Map.get(changeset, :errors) end)
      |> List.flatten

    results = case errors do
      [] -> 
        IO.puts "Validated... #{inspect errors} "
        Tokyo.Repo.insert_all(Tokyo.Db.ExerciseSet, sets_to_save)
      errors -> {:error, errors}
    end 
    
    case results do 
      {n, nil} -> 
        IO.puts "Created #{n} exercise sets for #{ex_rec_id}..."
        {:ok, sets_to_save}
      {n, inserted} -> 
        IO.puts "Created #{n} exercise sets for #{ex_rec_id}... #{inspect inserted}"
        {:ok, inserted}
      {:error, error} -> 
        IO.puts "Errors creating exercise sets for #{ex_rec_id}: #{inspect error}"
        {:error, error}
    end
  end

  defp validate(ex_set) do
    %Tokyo.Db.ExerciseSet{}
      |> Tokyo.Db.ExerciseSet.changeset(ex_set)
  end   

  defp to_model(ex_set_db) do
    IO.inspect ex_set_db
    %{
      "exerciseSetId" => ex_set_db.ex_set_id,
      "exerciseRecId" => ex_set_db.ex_rec_id,
      "reps" => ex_set_db.reps,
      "weight" => ex_set_db.weight,
    }
  end

end