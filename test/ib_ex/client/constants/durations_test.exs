defmodule IbEx.Client.Constants.DurationsTest do
  use ExUnit.Case, async: true

  alias IbEx.Client.Constants.Durations

  describe "durations/1" do
    test "returs a map of valid duration_unit values" do
      assert Durations.durations() == %{
               second: "S",
               day: "D",
               week: "W",
               month: "M",
               year: "Y"
             }
    end
  end

  describe "format/1" do
    test "creates valid duration format" do
      assert Durations.format({1, :second}) == "1 S"
      assert Durations.format({2, :day}) == "2 D"
      assert Durations.format({3, :week}) == "3 W"
    end

    test "returns :invalid_args for bad arguments" do
      assert Durations.format({0, :second}) == :invalid_args
      assert Durations.format({-1, :second}) == :invalid_args
      assert Durations.format({1, :bad_arg}) == :invalid_args
      assert Durations.format(:bad_arg) == :invalid_args
    end
  end
end
