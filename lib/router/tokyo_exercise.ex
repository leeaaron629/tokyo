defmodule Tokyo.Exercise do
    
    use Plug.Router

    plug :match
    plug Plug.Parsers,  parsers: [:json],
                        pass: ["application/json"],
                        json_decoder: Jason
    plug :dispatch

    get "/users/:user_id/exercises" do

        IO.puts "Fetching exercises for #{user_id}"

        send_resp(conn, 200, "")
    end

    post "/users/:user_id/exercises" do

        IO.puts "Saving an exercise for #{user_id}"

        IO.puts "#{inspect conn.body_params}"

        send_resp(conn, 201, "")
    end

    put "/users/:user_id/exercises/:exercise_id" do

        IO.puts "Updating exercise #{exercise_id} for #{user_id}"

        send_resp(conn, 200, "")
    end

    delete "/users/:user_id/exercises/:exercise_id" do

        IO.puts "Deleting exercise #{exercise_id} for #{user_id}"

        send_resp(conn, 204, "")
    end

    match _ do
        send_resp(conn, 404, "Endpoint does not exists in Tokyo")
    end

end