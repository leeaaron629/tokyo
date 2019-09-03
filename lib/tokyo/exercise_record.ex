defmodule Tokyo.ExerciseRecord do
    use Ecto.Schema

    schema "exercise_records" do
        field :ex_rec_id, Ecto.UUID
        field :ex_id, Ecto.UUID
        field :reps, :integer
        field :weights, :integer
        field :created_date, :naive_datetime
        field :created_by, :string
    end

end
