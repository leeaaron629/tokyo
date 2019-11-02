defmodule Tokyo.Service.ExerciseRecord do

    alias Tokyo.Repo.ExerciseRecord

    def fetch_exercise_records_by_user_id(user_id) do
        IO.puts "Fetching exercises for #{user_id}"
        ExerciseRecord.get_exercise_records(user_id)
    end

    def save_exercise_rec(ex_rec, user_id) do
        IO.puts "Saving exercise record #{inspect ex_rec} for #{inspect user_id}"

        case Map.get(ex_rec, "ex_rec_id") do
            nil -> Map.put(ex_rec, "ex_rec_id", Ecto.UUID.generate)
            _-> ex_rec
        end
        |> ExerciseRecord.save_exercise_records(user_id)
    end

    def delete_exercise_rec(id, user_id) do
        IO.puts "Deleting exercise record #{inspect id} from #{inspect user_id}"
        ExerciseRecord.remove_exercise_records(id, user_id)
    end
    
end