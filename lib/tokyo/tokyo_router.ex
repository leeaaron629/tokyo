defmodule Tokyo.Router do

    use Plug.Router

    plug :match
    plug Plug.Parsers,  parsers: [:json],
                        pass: ["application/json"],
                        json_decoder: Jason
    plug :dispatch

    alias Tokyo.Service.ExerciseRecord, as: ExerciseRecService

    # User Endpoints

    # Exercise Endpoints

    get "/users/:user_id/exercise-records" do
        response = ExerciseRecService.fetch_exercise_records_by_user_id(user_id)
        |> Enum.map(fn ex_rec -> ExerciseRecord.to_map(ex_rec) end)
        |> Jason.encode!
        send_resp(conn, 200, response)
    end

    post "/users/:user_id/exercise-records" do
        response = conn.body_params 
        |> ExerciseRecord.to_struct
        |> ExerciseRecService.save_exercise_rec(user_id)
        |> ExerciseRecord.to_mapa
        |> Jason.encode!
        send_resp(conn, 201, response)
    end

    put "/users/:user_id/exercise-records/:ex_rec_id" do
        send_resp(conn, 200, "Updating an exercise records")
    end

    delete "/users/:user_id/exercise-records/:ex_rec_id" do

        send_resp(conn, 204, "Deleting an exercise records")
    end

    match _ do
        send_resp(conn, 404, "URI does not exists in Tokyo")
    end

end