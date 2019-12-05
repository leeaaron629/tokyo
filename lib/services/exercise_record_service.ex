defmodule Tokyo.Service.ExerciseRecord do

    alias Tokyo.Repo.ExerciseRecord

    def fetch_exercise_records_by_user_id(user_id) do
        IO.puts "Fetching exercises for #{user_id}"
        case exercise_records = ExerciseRecord.get_exercise_records(user_id) do
            nil -> []
            _ -> Map.values(exercise_records)
        end
    end

    def fetch_an_exercise_record(user_id, ex_rec_id) do
        IO.puts "Fetching exercise record for #{user_id} [#{ex_rec_id}]"

    end

    def save_exercise_rec(ex_rec, user_id) do
        IO.puts "Saving exercise record for #{inspect user_id}"
        IO.inspect ex_rec

        ex_rec_to_save = case Map.get(ex_rec, :ex_rec_id) do
            nil -> Map.put(ex_rec, :ex_rec_id, Ecto.UUID.generate)
            _-> ex_rec
        end
        ExerciseRecord.save_exercise_records(ex_rec_to_save, user_id)

        ex_rec_to_save
    end

    def delete_exercise_rec(id, user_id) do
        IO.puts "Deleting exercise record #{inspect id} from #{inspect user_id}"
        ExerciseRecord.remove_exercise_records(id, user_id)
    end

end
