defmodule Tokyo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :user_name, :string
      add :email, :string
      add :password, :string
      add :first_name, :string
      add :last_name, :string
      add :age, :integer
    end
  end
end