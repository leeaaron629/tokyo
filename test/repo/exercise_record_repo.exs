defmodule TokyoTest.Repo.ExerciseRecord do
    
    use ExUnit.Case
    doctest Tokyo.Repo.ExerciseRecord

    alias UUID

    alias Tokyo.Repo

    test "create and fetch exercise records for user" do
        
        %{
            "ex_rec_id" => Ecto.UUID.generate,
            "exercise_id" => Ecto.UUID.generate,
            "sets" => [%Set{weight: 10_000, reps: 5}]
        }
        |> Repo.ExerciseRecord.save_exercise_records("Aaron")

        %{
            "ex_rec_id" => Ecto.UUID.generate,
            "exercise_id" => Ecto.UUID.generate,
            "sets" => [%Set{weight: 10_500, reps: 5}]
        }
        |> Repo.ExerciseRecord.save_exercise_records("Benjamin")
        
        uuid_to_get = Ecto.UUID.generate
        %{
            "ex_rec_id" => uuid_to_get,
            "exercise_id" => Ecto.UUID.generate,
            "sets" => [%Set{weight: 20_000, reps: 10}]
        }
        |> Repo.ExerciseRecord.save_exercise_records("Benjamin")

        # Make sure get exercise records does not change state
        exercise_records = Repo.ExerciseRecord.get_exercise_records("Benjamin")
        exercise_records = Repo.ExerciseRecord.get_exercise_records("Benjamin")

        assert exercise_records != nil
        assert Map.get(exercise_records, uuid_to_get) != nil

    end

    test "create and delete a exercise record for user" do
        
        uuid_to_delete = Ecto.UUID.generate
        %{
            "ex_rec_id" => uuid_to_delete,
            "exercise_id" => Ecto.UUID.generate,
            "sets" => [%Set{weight: 10_500, reps: 5}]
        }
        |> Repo.ExerciseRecord.save_exercise_records("Benjamin")
        
        uuid_to_get = Ecto.UUID.generate
        %{
            "ex_rec_id" => uuid_to_get,
            "exercise_id" => Ecto.UUID.generate,
            "sets" => [%Set{weight: 20_000, reps: 10}]
        }
        |> Repo.ExerciseRecord.save_exercise_records("Benjamin")

        Repo.ExerciseRecord.remove_exercise_records(uuid_to_delete, "Benjamin")
        exercise_records = Repo.ExerciseRecord.get_exercise_records("Benjamin")

        assert Map.get(exercise_records, uuid_to_delete) == nil
        assert Map.get(exercise_records, uuid_to_get) != nil

    end


end