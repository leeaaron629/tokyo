defmodule TokyoTest.Service.ExerciseRecord do

    use ExUnit.Case
    doctest Tokyo.Service.ExerciseRecord

    alias Tokyo.Service.ExerciseRecord

    @default_payload %{
        "exercise_rec_id" => "EX_123",
        "sets" => [
            %{weight_in_grams: 10000, reps: 5},
            %{weight_in_grams: 20000, reps: 3},
            %{weight_in_grams: 30000, reps: 1}
        ]
    }

    test "create, then fetch, and delete exercise record" do
        
        saved_record = @default_payload
        |> Map.put("created_date", now())
        |> ExerciseRecord.save_exercise_rec("leeaaron326")

    end

    defp now do
        NaiveDateTime.utc_now |> NaiveDateTime.truncate(:millisecond)
    end

    
end