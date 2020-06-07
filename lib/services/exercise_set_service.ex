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

  def save_all(nil, _), do: {:ok, []}
  def save_all(ex_sets, ex_rec_id) do
    IO.puts "Creating exercise sets for #{inspect ex_rec_id}... #{inspect ex_sets}"
    
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
        model_sets = sets_to_save |> Enum.map(fn set -> to_model(set) end)
        {:ok, model_sets}
      {n, inserted} -> 
        IO.puts "Created #{n} exercise sets for #{ex_rec_id}... #{inspect inserted}"
        {:ok, inserted}
      {:error, error} -> 
        IO.puts "Errors creating exercise sets for #{ex_rec_id}: #{inspect error}"
        {:error, error}
    end
    |> IO.inspect
  end

  def save_one(ex_set, ex_rec_id) do
    case ex_set["ex_set_id"] do
      nil -> create(ex_set)
      _ -> update(ex_set)
    end
  end

  defp create(ex_set) do
    IO.puts "Creating exercise set #{inspect ex_set}"
    %Tokyo.Db.ExerciseSet{}
      |> Tokyo.Db.ExerciseSet.changeset(ex_set)
      |> Tokyo.Repo.insert_or_update
      |> case do
        {:ok, created_ex_set} -> to_model(created_ex_set)
        {:error, changeset} -> IO.puts "Error has occured: #{inspect changeset}"
      end
  end

  defp update(ex_set) do
    IO.puts "Updating exercise set #{inspect ex_set}"
    ex_set_id = ex_set.ex_set_id
    ex_rec_id = ex_set.ex_rec_id
    current = Tokyo.Db.ExerciseSet
      |> where(ex_set_id: ^ex_set_id, ex_rec_id: ^ex_rec_id)
      |> Tokyo.Repo.one

    Tokyo.Db.ExerciseSet.changeset(current, ex_set)
      |> Tokyo.Repo.update
      |> case do
        {:ok, updated_ex_sec} -> to_model(updated_ex_sec)
        {:error, changeset} -> IO.puts "Error updating exercise set: #{inspect changeset}"
      end
      
  end
  
  def delete_ex_set(ex_set_id) do
    Tokyo.Db.ExerciseSet
      |> where(ex_set_id: ^ex_set_id)
      |> Tokyo.Repo.one
      |> Tokyo.Repo.delete
      |> case do
        {:ok, ex_set} -> IO.puts "Deleted #{inspect ex_set}"
        {:error, changeset} -> IO.puts "Error occured during deletion: #{inspect changeset}"
      end
  end

  def delete_ex_sets(ex_rec_id) do
    IO.puts "Deleting all exercise sets of exercise record - #{ex_rec_id}" 
    results = from(
      es in Tokyo.Db.ExerciseSet,
      where: es.ex_rec_id == ^ex_rec_id
    )
      |> Tokyo.Repo.delete_all
      |> case do
        {updated, _} -> {:ok, updated}
        {:error, error} -> {:error, error}
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
      "reps" => ex_set_db.reps,
      "weight" => ex_set_db.weight,
    }
  end

end