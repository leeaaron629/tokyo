defmodule Tokyo.ExerciseRecord do

    use Ecto.Schema
    import Ecto.Changeset

    schema "exercise_records" do
        field :ex_rec_id, Ecto.UUID
        field :ex_id, Ecto.UUID
        field :reps, :integer
        field :weights, :integer
        field :created_date, :naive_datetime
        field :created_by, :string
    end

    def changeset(exercise_record, params \\ %{}) do
        exercise_record
        |> cast(params, [:ex_rec_id, :ex_id, :reps, :weights, :created_date, :created_by])
    end

end
