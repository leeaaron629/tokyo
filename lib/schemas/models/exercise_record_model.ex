defmodule Tokyo.Model.ExerciseRecord do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
        field :workoutId, :string
        field :exerciseName, :string
        field :createdDate, :utc_datetime
        field :sets, {:array, {:map, :integer}}
    end

    def changeset(exercise_rec, params \\ %{}) do
        exercise_rec
        |> cast(params, [:sets, :workoutId, :exerciseName, :createdDate])
    end
end