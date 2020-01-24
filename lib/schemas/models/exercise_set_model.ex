defmodule Tokyo.Model.ExerciseSet do
    use Ecto.Schema
    
    embedded_schema do
        field :weight, :integer
        field :reps, :integer
    end
end