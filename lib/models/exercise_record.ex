defmodule Tokyo.ExerciseRecord do
    defstruct   ex_rec_id: nil,
                exercise_name: nil,
                sets: [],
                created_date: nil,
                completed_date: nil

    def to_struct(map) do
        %Tokyo.ExerciseRecord{
            ex_rec_id: Map.get(map, "ex_rec_id"),
            exercise_name: Map.get(map, "exercise_name"),
            sets: Map.get(map, "sets"),
            created_date: Map.get(map, "created_date"),
            completed_date: Map.get(map, "completed_date")
        }
    end

    def to_map(struct = %Tokyo.ExerciseRecord{}) do
        Map.delete(struct, :__struct__)
    end
end
