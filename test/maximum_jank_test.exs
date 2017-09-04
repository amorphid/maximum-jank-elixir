defmodule MaximumJankTest do
  use ExUnit.Case, async: true
  import MaximumJank

  describe "&module!/1" do
    test "returns module",  do: assert module!(MaximumJank) == MaximumJank

    test "raises an error" do
      assert_raise RuntimeError, ~r/not a module/, fn -> module!(FakeModule) end
    end
  end

  describe "&module?/1" do
    test "is true",  do: assert module?(MaximumJank) == true

    test "is false" do
      assert module?(FakeModule) == false
      assert module?(123) == false
      assert module?(%{}) == false
      assert module?({1,2,3}) == false
    end
  end
end
