defmodule Tokyo.Repo.ExerciseRecord do
    
    use GenServer

    @me __MODULE__

    def init(initial_state) do
        {:ok, initial_state}
    end

    def start_link(initial_state) do
        GenServer.start_link(@me, initial_state, name: @me)
    end

    # Get Exercise Records from the user

    def get_exercise_records(user_id) do
        GenServer.call(@me, {:get_ex_rec, user_id})
    end

    # Save Exercise Records from the user

    def save_exercise_records(ex_rec, user_id) do
        GenServer.cast(@me, {:save_ex_rec, ex_rec, user_id})
    end

    # Remove Exercise Record from the user

    def remove_exercise_records(ex_rec_id, user_id) do
        GenServer.cast(@me, {:remove_ex_rec, ex_rec_id, user_id})
    end

    def handle_call({:get_ex_rec, user_id}, _from, current_state) do
        # IO.puts "Current state: #{inspect current_state}"
        # IO.puts "Return value: #{inspect current_state[user_id]}"
        {:reply, current_state[user_id], current_state}
    end

    def handle_cast({:remove_ex_rec, ex_rec_id, user_id}, current_state) do
        
        exercise_records = Map.get(current_state, user_id)
        updated_exercise_records = Map.delete(exercise_records, ex_rec_id)

        new_state = Map.put(current_state, user_id, updated_exercise_records)
        {:noreply, new_state}
    end

    def handle_cast({:save_ex_rec, ex_rec, user_id}, current_state) do
        
        exercise_records = Map.get(current_state, user_id, %{})
        updated_exercise_records = Map.put(exercise_records, ex_rec["ex_rec_id"], ex_rec)

        new_state = Map.put(current_state, user_id, updated_exercise_records)
        {:noreply, new_state} 
    end

end