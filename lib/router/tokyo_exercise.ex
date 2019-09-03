defmodule Tokyo.Exercise do
    
    alias Tokyo.ExerciseService

    use Plug.Router

    plug :match
    plug Plug.Parsers,  parsers: [:json],
                        pass: ["application/json"],
                        json_decoder: Jason
    plug :dispatch

    get "/users/:user_id/exercises" do

        send_resp(conn, 200, "")
    end

    post "/users/:user_id/exercises" do

        ExerciseService.create_exercise_record(conn.body_params, user_id)

        send_resp(conn, 201, "")
    end

    put "/users/:user_id/exercises/:exercise_id" do

        send_resp(conn, 200, "")
    end

    delete "/users/:user_id/exercises/:exercise_id" do\

        send_resp(conn, 204, "")
    end

    match _ do
        send_resp(conn, 404, "Endpoint does not exists in Tokyo")
    end

end