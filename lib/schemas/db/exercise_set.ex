defmodule Tokyo.Db.ExerciseSet do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix "tokyo"
  @primary_key {:ex_set_id, :binary_id, []}

  @fields [
    :ex_set_id,
    :ex_rec_id,
    :weight,
    :reps
  ]

  @required_fields [
    :ex_rec_id,
    :weight,
    :reps
  ]

  schema "exercise_sets" do
    field :ex_rec_id, :binary_id
    field :weight, :integer
    field :reps, :integer 
  end

  def changeset(exercise_set, params \\ %{}) do 
    exercise_set
      |> cast(params, @fields)
      |> validate_required(@required_fields)
  end

end