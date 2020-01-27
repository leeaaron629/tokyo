defmodule Tokyo.Db.ExerciseRecord do

    use Ecto.Schema
    import Ecto.Changeset

    @fields [
        :ex_rec_id, 
        :ex_id, 
        :ex_name, 
        :user_id,
        :workout_id, 
        :reps, 
        :weights, 
        :created_date,
    ]
    @required_fields [
        :ex_rec_id,
        :ex_name, 
        :user_id, 
        :created_date,
    ]

    schema "exercise_records" do
        field :ex_rec_id, :binary_id
        field :ex_id, :string
        field :ex_name, :string
        field :user_id, :string
        field :workout_id, :string
        field :reps, {:array, :integer}
        field :weights, {:array, :integer}
        field :created_date, :utc_datetime
    end

    def changeset(exercise_record, params \\ %{}) do
        exercise_record
        |> cast(params, @fields)
        |> validate_required(@required_fields)
    end

end
