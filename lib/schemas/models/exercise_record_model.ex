defmodule Tokyo.Model.ExerciseRecord do
    use Ecto.Schema

    embedded_schema do
        field :workoutId, :string
        field :exerciseName, :string
        field :createdDate, :utc_datetime
        has_many :sets, Tokyo.Model.ExerciseSet
    end
end