defmodule NeuronTest do
  use ExUnit.Case
  doctest Neuron
  require IEx

    test "starts a linked neuron with the default parameters" do
      assert {:ok, neuron} = Neuron.start_link
      assert is_pid neuron
    end

    test "neuron accepts multiple input charges" do
      assert {:ok, neuron} = Neuron.start_link
      assert :ok == GenServer.cast neuron, {:electrocute, %{amount: 0.1, sender: self}}
      assert :ok == GenServer.cast neuron, {:electrocute, %{amount: 0.5, sender: self}}
      assert :ok == GenServer.cast neuron, {:electrocute, %{amount: 0.3, sender: neuron}}
    end

    test "neuron returns the state upon calling" do
      assert {:ok, neuron} = Neuron.start_link
      assert {:ok, state}  = Neuron.state? neuron
      assert [current_charge: _current_charge, activation_level: _activation_level, outgoing_nodes: _outgoing_nodes] = state
    end

    test "neuron accepts other neurons as outputs" do
      assert {:ok, neuron}  = Neuron.start_link
      assert {:ok, neuron2} = Neuron.start_link
      assert {:ok, neuron3} = Neuron.start_link
      Neuron.add_output(neuron, neuron2)
      Neuron.add_output(neuron, neuron3)
      assert {:ok, state} = Neuron.state?(neuron)
      assert Keyword.get(state, :outgoing_nodes) == [neuron2, neuron3]
    end

    test "neuron can be charged" do
      assert {:ok, neuron} = Neuron.start_link
      assert :ok ==  Neuron.electrocute(neuron, 0.1)
      assert {:ok, state } = Neuron.state?(neuron)
      assert state[:current_charge] > 0.05
      assert state[:current_charge] <= 0.1
    end

     test "explodes if the activation level is hit :-)" do
     end

    test "sleeps after an explosion" do
      assert {:ok, neuron} = Neuron.start_link
    end





end