defmodule IbEx.Client.Messages.MarketData.Tick.PriceTest do
  use ExUnit.Case, async: true

  alias IbEx.Client.Messages.MarketData.Tick.Price
  alias IbEx.Client.Protocols.Subscribable
  alias IbEx.Client.Subscriptions

  describe "from_fields/1" do
    test "creates the message valid fields" do
      assert {:ok, msg} = Price.from_fields(["6", "123", "1", "100.5", "200", "7"])

      assert msg.request_id == "123"
      assert msg.tick_type == :bid
      assert msg.price == 100.5
      assert msg.size == Decimal.new("200")
      assert msg.can_autoexecute?
      assert msg.past_limit?
      assert msg.pre_open?
      refute msg.should_tick_for_size?
    end

    test "returns an error with invalid args" do
      assert {:error, :invalid_args} == Price.from_fields(["123", "1", "100.50", "200"])
    end
  end

  describe "Inspect implementation" do
    test "inspects Price struct correctly" do
      msg = %Price{
        request_id: "123",
        tick_type: :bid,
        price: 100.5,
        size: Decimal.new("200"),
        can_autoexecute?: true,
        past_limit?: false,
        pre_open?: true,
        should_tick_for_size?: false
      }

      assert inspect(msg) ==
               """
               <-- %MarketData.Tick.Price{
                 request_id: 123,
                 tick_type: bid,
                 price: 100.5,
                 size: 200,
                 can_autoexecute?: true,
                 past_limit?: false,
                 pre_open?: true,
                 should_tick_for_size?: false
               }
               """
    end
  end

  describe "Subscribable" do
    test "looks up the message in the subscriptions mapping" do
      table_ref = Subscriptions.initialize()
      Subscriptions.subscribe_by_request_id(table_ref, self())
      {:ok, msg} = Price.from_fields(["1", "1", "1", "100.5", "200", "7"])

      assert {:ok, pid} = Subscribable.lookup(msg, table_ref)
      assert pid == self()
    end
  end
end