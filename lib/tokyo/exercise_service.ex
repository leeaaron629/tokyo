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

    defp payload_to_struct(empty_struct, payload) do
        
        string_keys_map = 
            Map.from_struct(empty_struct)
            |> Map.to_list
            |> Enum.map(fn {k, v} -> {Atom.to_string(k), v} end)
            |> Map.new
            |> Map.delete("__meta__")

        payload_with_atom_keys = 
            for {k, v} <- payload, into: %{} do
                case Map.fetch(string_keys_map, k) do
                    {:ok, _val} -> {String.to_existing_atom(k), v}
                    :error -> {k, v}
                end
            end
        
        struct(empty_struct.__struct__, payload_with_atom_keys)

    end

end