defmodule IbEx.Client.Messages.MarketData.Tick.GenericTest do
  use ExUnit.Case, async: true

  alias IbEx.Client.Messages.MarketData.Tick.Generic
  alias IbEx.Client.Protocols.Subscribable
  alias IbEx.Client.Subscriptions

  describe "from_fields/1" do
    test "creates Generic struct with valid fields" do
      assert {:ok, msg} = Generic.from_fields(["", "9001", "49", "0.0"])

      assert msg.request_id == "9001"
      assert msg.tick_type == :halted
      assert msg.value == 0.0
    end

    test "returns an error with insufficient fields" do
      assert {:error, :invalid_args} == Generic.from_fields(["123", "1"])
    end
  end

  describe "Inspect implementation" do
    test "inspects TickSize struct correctly" do
      msg = %Generic{
        request_id: "9001",
        tick_type: :halted,
        value: 0.0
      }

      assert inspect(msg) ==
               "<-- %MarketData.Tick.Generic{request_id: 9001, tick_type: halted, value: 0.0}"
    end
  end

  describe "Subscribable" do
    test "looks up the message in the subscriptions mapping" do
      table_ref = Subscriptions.initialize()
      Subscriptions.subscribe_by_request_id(table_ref, self())
      {:ok, msg} = Generic.from_fields(["", "1", "49", "0.0"])

      assert {:ok, pid} = Subscribable.lookup(msg, table_ref)
      assert pid == self()
    end
  end
end