defmodule ExerciseRecord do
    defstruct   exercise_rec_id: nil,
                sets: [],
                created_date: nil,
                completed_date: nil

    def to_struct(map) do
        %ExerciseRecord{
            exercise_rec_id: Map.get(map, "exercise_rec_id"),
            sets: Map.get(map, "sets"),
            created_date: Map.get(map, "created_date"),
            completed_date: Map.get(map, "completed_date")
        }
    end
end