defmodule Tokyo.User do

    use Plug.Router

    plug :match
    plug Plug.Parsers,  parsers: [:json],
                        pass: ["application/json"],
                        json_decoder: Jason
    plug :dispatch

    get "/users" do
        send_resp(conn, 200, "Getting Users...")
    end

end