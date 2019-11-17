defmodule Tokyo.ExerciseRecord do
    defstruct   ex_rec_id: nil,
                exercise_id: nil,
                sets: [],
                created_date: nil,
                completed_date: nil

    def to_struct(map) do
        %Tokyo.ExerciseRecord{
            ex_rec_id: Map.get(map, "ex_rec_id"),
            exercise_id: Map.get(map, "exercise_id"),
            sets: Map.get(map, "sets"),
            created_date: Map.get(map, "created_date"),
            completed_date: Map.get(map, "completed_date")
        }
    end

    def to_map(struct = %Tokyo.ExerciseRecord{}) do
        Map.delete(struct, :__struct__)
    end
end
