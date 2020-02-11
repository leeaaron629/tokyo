defmodule Tokyo.Repo.Migrations.CreateExerciseRecords do
  use Ecto.Migration

  def change do
    create table(:exercise_records) do
      add :ex_rec_id, :uuid
      add :ex_name, :string
      add :ex_id, :int
      add :workout_id, :string
      add :user_id, :string
      add :reps, {:array, :integer}
      add :weights, {:array, :integer}
      add :created_date, :utc_datetime
    end
  end
end