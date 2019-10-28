defmodule Tokyo.Router do
    
    alias Tokyo.ExerciseService

    use Plug.Router

    plug :match
    plug Plug.Parsers,  parsers: [:json],
                        pass: ["application/json"],
                        json_decoder: Jason
    plug :dispatch

    # User Endpoints

    # Exercise Endpoints

    get "/users/:user_id/exercise-records" do
        response = ExerciseService.fetch_exercise_records_by_user_id(user_id)
        send_resp(conn, 200, "")
    end

    post "/users/:user_id/exercise-records" do
        response = ExerciseService.create_exercise_record(conn.body_params, user_id)
        send_resp(conn, 201, response)
    end

    put "/users/:user_id/exercise-records/:ex_rec_id" do
        response = ExerciseService.update_exercise_record(conn.body_params, ex_rec_id)
        send_resp(conn, 200, response)
    end

    delete "/users/:user_id/exercise-records/:ex_rec_id" do
        response = ExerciseService.update_exercise_record(conn.body_params, ex_rec_id)
        send_resp(conn, 204, "")
    end

    match _ do
        send_resp(conn, 404, "URI does not exists in Tokyo")
    end

end