defmodule Tokyo.ExerciseService do

    require Ecto.Query

    def fetch_exercise_records_by_user_id(user_id) do
        IO.puts "Fetching exercises for #{user_id}"

        Tokyo.ExerciseRecord 
        |> Ecto.Query.where(user_id: ^user_id) 
        |> Tokyo.Repo.all

    end
    
    def create_exercise_record(payload, user_id) do

        prepared_payload = payload 
        |> Map.put(:user_id, user_id)
        |> Map.put(:ex_rec_id, Ecto.UUID.generate)

        IO.puts "Saving an exercise for #{user_id}"
        IO.puts "#{inspect prepared_payload}"
        
        %Tokyo.ExerciseRecord{}
        |> Tokyo.ExerciseRecord.changeset(prepared_payload)
        |> Tokyo.Repo.insert
        |> case do
            {:ok, exercise_record} -> exercise_record
            {:error, changeset} -> IO.puts "Error has occured: #{inspect changeset}"
        end

    end

    def update_exercise_record(payload, id) do
        IO.puts "Updating exercise #{inspect payload} with id = #{id}"

        Tokyo.ExerciseRecord
        |> Ecto.Query.where(ex_rec_id: ^id)
        |> Tokyo.Repo.one
        |> Tokyo.ExerciseRecord.changeset(payload)
        |> Tokyo.Repo.update
        |> case do
            {:ok, exercise_record} -> exercise_record
            {:error, changeset} -> IO.puts "Error updating: #{inspect changeset}"
        end

    end

    def delete_exercise_record(id) do
        IO.puts "Deleting exercise with id = #{id}"

        Tokyo.ExerciseRecord
        |> Ecto.Query.where(ex_rec_id: ^id)
        |> Tokyo.Repo.one
        |> IO.inspect
        |> Tokyo.Repo.delete
        |> case do
            {:ok, exercise_record} -> IO.puts "Deleted #{inspect exercise_record}"
            {:error, changeset} -> IO.puts "Error occured during deletion: #{inspect changeset}"
        end

    end

end