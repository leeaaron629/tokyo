defmodule ExerciseRecord do
    defstruct   user_id: nil,
                exercise_rec_id: nil,
                sets: [],
                completedDate: NaiveDateTime.utc_now |> NaiveDateTime.truncate(:millisecond)
end