defmodule MaximumJankTest do
  use ExUnit.Case
  import MaximumJank

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
