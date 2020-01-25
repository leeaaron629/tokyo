defmodule Tokyo.Model.ExerciseSet do
    use Ecto.Schema
    
    embedded_schema do
        field :weight, :integer
        field :reps, :integer
    end

    def changeset(exercise_set, params \\ %{}) do
        exercise_set
        |> Ecto.Changeset.cast(params, [:weight, :reps])
    end
end