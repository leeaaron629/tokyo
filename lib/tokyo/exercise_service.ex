defmodule Tokyo.ExerciseService do

    require Ecto.Query

    def fetch_exercise_records_by_user_id(user_id) do
        IO.puts "Fetching exercises for #{user_id}"

        Tokyo.ExerciseRecord 
        |> Ecto.Query.where(user_id: ^user_id) 
        |> Tokyo.Repo.all

    end
    
    def create_exercise_record(payload, user_id) do
        IO.puts "Saving an exercise for #{user_id}"
        IO.puts "#{inspect payload}"
        
        %Tokyo.ExerciseRecord{}
        |> Tokyo.ExerciseRecord.changeset(payload)
        |> Tokyo.Repo.insert
        |> case do
            {:ok, exercise_record} -> exercise_record
            {:error, changeset} -> IO.puts "Error has occured"
        end

    end

    def update_exercise_record_by_id(payload, id) do
        IO.puts "Updating exercise #{payload} with id = #{id}"

        Tokyo.ExerciseRecord
        |> Ecto.Query.where(ex_id: ^id)
        |> Tokyo.Repo.one
        |> Tokyo.ExerciseRecord.changeset(payload)
        |> Tokyo.Repo.update
        |> case do
            {:ok, exercise_record} -> exercise_record
            {:error, changeset} -> IO.puts "Error updating"
        end

    end

    def delete_exercise_record_by_id(id) do
        IO.puts "Deleting exercise with id = #{id}"

        Tokyo.ExerciseRecord
        |> Ecto.Query.where(ex_id: ^id)
        |> Tokyo.Repo.one
        |> Tokyo.Repo.delete
        |> case do
            {:ok, exercise_record} -> IO.puts "Deleted #{inspect exercise_record}"
            {:error, changeset} -> IO.puts "Error occured during deletion"
        end

    end

end