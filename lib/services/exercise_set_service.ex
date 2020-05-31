defmodule Tokyo.Service.ExerciseSet do
  require Ecto.Query
  import Ecto.Query
  alias Tokyo.Db.ExerciseSet

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


end