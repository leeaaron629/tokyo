defmodule Tokyo.Db.ExerciseRecord do

    use Ecto.Schema
    import Ecto.Changeset

    @schema_prefix "tokyo"
    @primary_key {:ex_rec_id, :binary_id, []}

    @fields [
        :ex_rec_id,
        :ex_id, 
        :ex_name, 
        :user_id,
        :workout_id, 
        :created_date,
    ]

    @required_fields [
        :ex_name, 
        :user_id, 
        :created_date,
        :workout_id
    ]

    schema "exercise_records" do
        field :ex_id, :integer
        field :ex_name, :string
        field :user_id, :string
        field :workout_id, :binary_id
        field :created_date, :utc_datetime
    end

    def changeset(exercise_record, params \\ %{}) do
        exercise_record
        |> cast(params, @fields)
        |> validate_required(@required_fields)
    end

end
