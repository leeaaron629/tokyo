defmodule TokyoTest.ExerciseSetService do
  use ExUnit.Case
  doctest Tokyo.Service.ExerciseRecord

  alias Tokyo.Service.ExerciseSet, as: ExSetService
  alias Tokyo.Service.ExerciseRecord, as: ExRecService

  test "create exercise sets and fetch by their UUID" do
    ex_rec_id = Ecto.UUID.generate
    user_id = "@test_user"
    ex_id = Ecto.UUID.generate
    workout_id = Ecto.UUID.generate
    created_date = DateTime.utc_now |> DateTime.to_string
    sets = [
      %{"weight" => 155, "reps" => 10},
      %{"weight" => 185, "reps" => 5},
      %{"weight" => 205, "reps" => 3}
  ]

    ex_rec = %{
      # "exerciseRecId" => ex_rec_id,
      "exerciseId" => ex_id,
      "exerciseName" => "Squat",
      "workoutId" => workout_id,
      "createdDate" => created_date,
      "sets" => sets
    }

    saved_ex_rec = ExRecService.save(ex_rec, user_id)   
    fetched_ex_rec = ExRecService.get_one(saved_ex_rec["exerciseRecId"])
    
    assert saved_ex_rec != nil
    assert fetched_ex_rec != nil
    Enum.zip(sets, fetched_ex_rec["sets"])
      |> Enum.each(
      fn {expected, actual} ->
        assert expected["weight"] == actual["weight"]
        assert expected["reps"] == actual["reps"]
      end)
  end

  test "create exercise record and update it" do
    ex_rec_id = Ecto.UUID.generate
    user_id = "@test_user"
    ex_id = Ecto.UUID.generate
    workout_id = Ecto.UUID.generate
    created_date = DateTime.utc_now |> DateTime.to_string

    ex_rec = %{
      "exerciseId" => ex_id,
      "exerciseName" => "Squat",
      "workoutId" => workout_id,
      "createdDate" => created_date
    }

    saved_ex_rec = ExRecService.save(ex_rec, user_id)
    fetched_ex_rec = ExRecService.get_one(saved_ex_rec["exerciseRecId"])

    # Make sure it's empty
    assert fetched_ex_rec["sets"] == []

    sets_to_add = [
      %{"weight" => 155, "reps" => 10},
      %{"weight" => 185, "reps" => 5},
      %{"weight" => 205, "reps" => 3}
    ]

    first_update = saved_ex_rec |> Map.put("sets", sets_to_add)
    ExRecService.save(first_update, user_id)
    fetched_ex_rec = ExRecService.get_one(saved_ex_rec["exerciseRecId"])

    Enum.zip(sets_to_add, fetched_ex_rec["sets"])
      |> Enum.each(
        fn {expected, actual} ->
          assert expected["weight"] == actual["weight"]
          assert expected["reps"] == actual["reps"]
        end
      )

    sets_to_add = sets_to_add ++ [%{"weight" => 315, "reps" => 1}]
    second_update = first_update |> Map.put("sets", sets_to_add)
    ExRecService.save(second_update, user_id)
    fetched_ex_rec = ExRecService.get_one(saved_ex_rec["exerciseRecId"])
    
    Enum.zip(sets_to_add, fetched_ex_rec["sets"])
      |> Enum.each(
        fn {expected, actual} ->
          assert expected["weight"] == actual["weight"]
          assert expected["reps"] == actual["reps"]
        end
      ) 
  end

end