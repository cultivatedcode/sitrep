defmodule Sitrep.Workers.Config do
  use GenServer

  @moduledoc """
  Documentation for Config.
  Provides access to the config for services to monitor.
  """

  # Client

  @doc """
    Starts the config server.
  """
  def start_link(config_file_path) do
    GenServer.start_link(__MODULE__, [config_file_path], name: __MODULE__)
  end

  @doc """
    Returns a list of service configurations from the config file.
  """
  def services do
    GenServer.call(__MODULE__, {:services})
  end

  # Server (Callbacks)

  @impl true
  def init(file_path) do
    {:ok, body} = File.read(file_path)
    {:ok, json} = Poison.decode(body)
    {:ok, json}
  end

  @impl true
  def handle_call({:services}, _from, json) do
    services = json["services"]
    {:reply, services, json}
  end
end