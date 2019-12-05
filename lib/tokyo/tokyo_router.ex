defmodule Tokyo.Router do
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  alias Tokyo.Service.ExerciseRecord, as: ExerciseRecService
  alias Tokyo.ExerciseRecord

  # User Endpoints

  # Exercise Endpoints

  get "/users/:user_id/exercise-records" do
    task = Task.async(ExerciseRecService, :fetch_exercise_records_by_user_id, [user_id])

    response =
      Task.await(task)
      |> Enum.map(fn ex_rec -> ExerciseRecord.to_map(ex_rec) end)
      |> Jason.encode!()

    send_resp(conn, 200, response)
  end

  get "/users/:user_id/exercise-records/:ex_rec_id" do
    task = Task.async(ExerciseRecService, :fetch_an_exercise_record, [user_id, ex_rec_id])
    exercise_record = Task.await(task)

    response =
      case exercise_record do
        nil -> ""
        _ -> ExerciseRecord.to_map(exercise_record)
      end
      send_resp(conn, 200, response)
  end

  post "/users/:user_id/exercise-records" do
    exercise_record = ExerciseRecord.to_struct(conn.body_params)
    task = Task.async(ExerciseRecService, :save_exercise_rec, [exercise_record, user_id])

    response =
      Task.await(task)
      |> ExerciseRecService.save_exercise_rec(user_id)
      |> ExerciseRecord.to_map()
      |> Jason.encode!()

    send_resp(conn, 201, response)
  end

  put "/users/:user_id/exercise-records/:ex_rec_id" do
    exercise_record = ExerciseRecord.to_struct(conn.body_params)
    task = Task.async(ExerciseRecService, :save_exercise_rec, [exercise_record, user_id])

    response =
      Task.await(task)
      |> ExerciseRecord.to_map()
      |> Jason.encode!()

    send_resp(conn, 200, response)
  end

  delete "/users/:user_id/exercise-records/:ex_rec_id" do
    task = Task.async(ExerciseRecService, :delete_exercise_rec, [ex_rec_id, user_id])
    response = Task.await(task)
    send_resp(conn, 204, "")
  end

  match _ do
    send_resp(conn, 404, "URI does not exists in Tokyo\r\n")
  end
end
