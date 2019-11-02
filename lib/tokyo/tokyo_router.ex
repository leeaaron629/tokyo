defmodule Tokyo.Router do

    use Plug.Router

    plug :match
    plug Plug.Parsers,  parsers: [:json],
                        pass: ["application/json"],
                        json_decoder: Jason
    plug :dispatch

    alias Tokyo.Service.ExerciseRecord

    # User Endpoints

    # Exercise Endpoints

    get "/users/:user_id/exercise-records" do
        ExerciseRecord.fetch_exercise_records_by_user_id(user_id)
        send_resp(conn, 200, "Fetching exercise records")
    end

    post "/users/:user_id/exercise-records" do
        send_resp(conn, 201, "Creating an exercise records")
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