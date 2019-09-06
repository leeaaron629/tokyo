defmodule Tokyo.Repo.Migrations.CreateExerciseRecords do
  use Ecto.Migration

  def change do
    create table(:exercise_records) do
      add :ex_rec_id, :uuid
      add :ex_id, :uuid
      add :user_id, :uuid
      add :reps, :integer
      add :weights, :integer
      add :created_date, :naive_datetime
    end
  end
end
