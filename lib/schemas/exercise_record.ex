defmodule Tokyo.ExerciseRecord do

    use Ecto.Schema
    import Ecto.Changeset

    @fields [:ex_rec_id, :ex_id, :user_id, :reps, :weights, :created_date]

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
        |> cast(params, @fields)
        |> validate_required(@fields)
    end

end
