defmodule Neuron do
  @moduledoc false
  
  use GenServer
  require IEx

  ## client api
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  # returns the current state of a neuron
  def state?(of_pid) do
    GenServer.call of_pid, :how_are_you?
  end

  # adds an output neuron to a neuron
  def add_output(neuron_pid, output_pid) do
    GenServer.call neuron_pid, {:add_output, output_pid}
  end

  # server callbacks
  def init(:ok) do
    opts = [] # todo, start the genserver with options
    defaults = [current_charge: 0, activation_level: 1.0, outgoing_nodes: []]
    {:ok, Keyword.merge(defaults, opts)}
  end

  def handle_call(:how_are_you?, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:add_output, pid}, _from, state) do
    state = Keyword.put(state, :outgoing_nodes, Keyword.get(state, :outgoing_nodes) ++ [pid])
    {:reply, :ok, state}
  end

  def handle_cast({:electrocute, opts}, state) do
    # todo: do something useful
    {:noreply, state}
  end

  # helper functions


end