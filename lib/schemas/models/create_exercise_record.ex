defmodule Tokyo.Model.ExerciseRecord do
    use Ecto.Schema

    embedded_schema do
        field :workoutId, :string
        field :exerciseName, :string
        field :sets
    end
end