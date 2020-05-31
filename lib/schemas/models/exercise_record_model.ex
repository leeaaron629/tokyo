defmodule Tokyo.Model.ExerciseRecord do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
        field :exerciseRecId, :binary_id
        field :workoutId, :binary_id
        field :exerciseName, :string
        field :createdDate, :utc_datetime
        field :sets, {:array, {:map, :integer}}
    end

    def changeset(exercise_rec, params \\ %{}) do
        exercise_rec
        |> cast(params, [:workoutId, :exerciseName, :createdDate, :exerciseRecId, :sets])
    end
end