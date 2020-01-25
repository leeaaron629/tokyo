defmodule Tokyo.Db.User do
    use Ecto.Schema

    schema "users" do
        field :user_name, :string
        field :email, :string
        field :password, :string
        field :first_name, :string
        field :last_name, :string
        field :age, :integer
    end
end