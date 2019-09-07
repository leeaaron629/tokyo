defmodule TokyoTest.ExerciseService do
    
    use ExUnit.Case
    doctest Tokyo.ExerciseService

    alias Tokyo.ExerciseService

    require Ecto.Query

    @default_payload %{
        ex_id: "squat_123",
        reps: 5,
        weights: 135
    }

    test "insert, then delete exercise record" do

        saved_record = @default_payload
        |> Map.put(:created_date, now())
        |> ExerciseService.create_exercise_record("leeAaron326")

        assert saved_record != nil

        id = saved_record.ex_rec_id
        ExerciseService.delete_exercise_record(id)
        
        response = Tokyo.ExerciseRecord
        |> Ecto.Query.where(ex_rec_id: ^id)
        |> Tokyo.Repo.one
        
        assert response == nil

    end

    test "update an exercise record" do

        saved_record = @default_payload
        |> Map.put(:created_date, now())
        |> ExerciseService.create_exercise_record("forUpdateTest")

        assert saved_record != nil

        id = saved_record.ex_rec_id

        ExerciseService.update_exercise_record(%{reps: 10, weights: 95}, id)

        response = Tokyo.ExerciseRecord
        |> Ecto.Query.where(ex_rec_id: ^id)
        |> Tokyo.Repo.one

        IO.puts "Response after updating... #{inspect response}"

        assert response.reps == 10
        assert response.weights == 95

        ExerciseService.delete_exercise_record(id)
    
        response = Tokyo.ExerciseRecord
        |> Ecto.Query.where(ex_rec_id: ^id)
        |> Tokyo.Repo.one
        
        assert response == nil
        
    end

    test "fetch all exercise records by user id" do

        user_to_fetch = "forFetchExerciseTest"

        response_1 = @default_payload
        |> Map.put(:created_date, now())
        |> ExerciseService.create_exercise_record(user_to_fetch)

        response_2 = @default_payload
        |> Map.put(:created_date, now())
        |> ExerciseService.create_exercise_record(user_to_fetch)

        exercise_records = ExerciseService.fetch_exercise_records_by_user_id(user_to_fetch)

        assert length(exercise_records) == 2

        ExerciseService.delete_exercise_record(response_1.ex_rec_id)
        ExerciseService.delete_exercise_record(response_2.ex_rec_id)

    end

    defp now do
        NaiveDateTime.utc_now |> NaiveDateTime.truncate(:millisecond)
    end

end