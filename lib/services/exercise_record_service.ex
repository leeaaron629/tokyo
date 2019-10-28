defmodule Tokyo.Service.ExerciseRecord do

    def fetch_exercise_records_by_user_id(user_id) do
        IO.puts "Fetching exercises for #{user_id}"
    end

    def save_exercise_rec(exercise_rec, user_id) do
        IO.puts "Saving exercise record #{inspect exercise_rec} for #{inspect user_id}"
    end

    def delete_exercise_rec(id) do
        IO.puts "Deleting exercise record #{inspect id}"
    end
    
end