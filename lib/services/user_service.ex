defmodule Tokyo.Service.User do
    
    def fetch_user_by_id(id) do
        IO.puts "Fetching user #{inspect id}"
    end

    def save_user(user) do
        IO.puts "Saving #{inspect user}"
    end

end