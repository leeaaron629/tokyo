defmodule TokyoTest.Repo.ExerciseRecord do
    
    use ExUnit.Case
    doctest Tokyo.Repo.ExerciseRecord

    alias UUID

    alias Tokyo.Repo

    test "create and fetch exercise records for user" do
        
        %{
            "ex_rec_id" => Ecto.UUID.generate,
            "sets" => []
        }
        |> Repo.ExerciseRecord.save_exercise_records("Aaron")

        exercise_records = Repo.ExerciseRecord.get_exercise_records("Aaron")
        IO.puts ("Aaron's Exercise Records:\n #{inspect exercise_records}")

        %{
            "ex_rec_id" => Ecto.UUID.generate,
            "sets" => []
        }
        |> Repo.ExerciseRecord.save_exercise_records("Benjamin")

        exercise_records = Repo.ExerciseRecord.get_exercise_records("Benjamin")
        IO.puts ("Benjamin's Exercise Records:\n #{inspect exercise_records}")

    end

end