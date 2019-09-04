defmodule Tokyo.ExerciseService do

    def fetch_exercise_records_by_user_id(user_id) do
        IO.puts "Fetching exercises for #{user_id}"
    end
    
    def create_exercise_record(payload, user_id) do
        IO.puts "Saving an exercise for #{user_id}"
        IO.puts "#{inspect payload}"

        Tokyo.ExerciseRecord.changeset(%Tokyo.ExerciseRecord{}, payload)
        |> Tokyo.Repo.insert

    end

    def update_exercise_record_by_id(payload, id) do
        IO.puts "Updating exercise #{payload} with id = #{id}"
    end

    def delete_exercise_record_by_id(id) do
        IO.puts "Deleting exercise with id = #{id}"
    end

end