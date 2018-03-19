defmodule Cache do
  # defmodule CacheOtp.Worker do
  use GenServer
  @name COTP

  # - - - - - - - -
  # Client API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: COTP])
  end

  def write(key, value) do
    GenServer.call(@name, {:write, key, value})
  end

  def inspect do
    GenServer.call(@name, :inspect_cache)
  end

  def read(key) do
    GenServer.call(@name, {:read, key})
  end

  def delete(key) do
    GenServer.call(@name, {:delete, key})
  end

  def exist?(key) do
    GenServer.call(@name, {:exist, key})
  end

  def clear do
    GenServer.cast(@name, :clear)
  end

  # - - - - - - - -
  # Server Callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:write, key, value}, _from, data) do
    new_data = Map.put_new(data, key, value)
    {:reply, new_data, new_data}
  end

  def handle_call(:inspect_cache, _from, data) do
    {:reply, data, data}
  end

  def handle_call({:read, key}, _from, data) do
    {:ok, value} = Map.fetch(data, key)
    {:reply, value, data}
  end

  def handle_call({:delete, key}, _from, data) do
    new_data = Map.delete(data, key)
    {:reply, new_data, new_data}
  end

  def handle_call({:exist, key}, _from, data) do
    response = Map.has_key?(data, key)
    {:reply, response, data}
  end

  def handle_cast(:clear, _data) do
    {:noreply, %{}}
  end

  # - - - - - - - -
  # Helper Functions
end

# Cache.write(:stooges, ["Larry", "Curly", "Moe"])
# Cache.read(:stooges)
# Cache.delete(:stooges)
# Cache.clear
# Cache.exist?(:stooges)
