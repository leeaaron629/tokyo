defmodule TokyoTest.Sandbox do
  use ExUnit.Case
  
  alias Tokyo.Service.ExerciseRecord, as: ExRecService
  alias Tokyo.Service.ExerciseService, as: ExSetService

  test "get one by exercise record id" do    
    fetched_ex_rec = "0626dd1b-1ebc-4c71-8a19-78527f8512b6"
      |> Ecto.UUID.cast!
      |> ExRecService.get_one()
      |> IO.inspect
  
  end

end