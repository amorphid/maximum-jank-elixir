defmodule MaximumJankTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog
  import MaximumJank

  describe "&__using__/1" do
    test "raises an error is used outside module"do
      pattern = ~r/cannot invoke 'use MaximumJank' outside module/
      func = fn -> Code.compile_string("use MaximumJank") end
      assert_raise RuntimeError, pattern, func
    end

    test "using once inside module does not raise error" do
      file =
        """
        defmodule UsingOnce do
          use MaximumJank
        end
        """
      assert Code.compile_string(file)
    end

    test "using twice inside module does not raise error" do
      file =
        """
        defmodule UsingTwice do
          use MaximumJank
          use MaximumJank
        end
        """
      assert Code.compile_string(file)
    end
  end

  describe "&__using__!/1" do
    test "raises error if not in module" do
      pattern = ~r/cannot invoke &MaximumJank.__using__!\/1 outside module/
      func = fn -> Code.compile_string("MaximumJank.__using__!(__ENV__)") end
      assert_raise RuntimeError, pattern, func
    end

    test "raises error if without 'use MaximumJank'" do
      file =
        """
        defmodule InNotUsing do
          MaximumJank.__using__!(__ENV__)
        end
        """
      pattern = ~r/you must declare 'use MaximumJank' to invoke &MaximumJank.__using__!\/1/
      func = fn -> Code.compile_string(file) end
      assert_raise RuntimeError, pattern, func
    end

    test "raises error if 'require' is used" do
      file =
        """
        defmodule Requiring do
          require MaximumJank
          MaximumJank.__using__!(__ENV__)
        end
        """
      pattern = ~r/you must declare 'use MaximumJank' to invoke &MaximumJank.__using__!\/1/
      func = fn -> Code.compile_string(file) end
      assert_raise RuntimeError, pattern, func
    end

    test "raises error if 'import' is used" do
      file =
        """
        defmodule Importing do
          import MaximumJank
          MaximumJank.__using__!(__ENV__)
        end
        """
      pattern = ~r/you must declare 'use MaximumJank' to invoke &MaximumJank.__using__!\/1/
      func = fn -> Code.compile_string(file) end
      assert_raise RuntimeError, pattern, func
    end
  end

  describe "&__using__?/1" do

    test "returns false if not using" do
      func = fn ->
        file =
          """
          defmodule NotUsing do
            require Logger
            _ = MaximumJank.__using__?(__ENV__) |> Logger.error()
          end
          """
        Code.compile_string(file)
      end
      assert capture_log(func) =~ "false"
    end
    @tag :potato
    test "returns true if using" do
      func = fn ->
        file =
          """
          defmodule Using do
            require Logger
            use MaximumJank
            _ = MaximumJank.__using__?(__ENV__) |> Logger.error()
          end
          """
        Code.compile_string(file)
      end
      assert capture_log(func) =~ "true"
    end

    test "raises error if not in module" do
      pattern = ~r/cannot invoke &MaximumJank.__using__\?\/1 outside module/
      func = fn -> Code.compile_string("MaximumJank.__using__?(__ENV__)") end
      assert_raise RuntimeError, pattern, func
    end
  end

  describe "&module!/1" do
    test "returns module" do
      assert module!(MaximumJank) == MaximumJank
      assert module!(:ssl) == :ssl
    end

    test "raises an error" do
      assert_raise RuntimeError, ~r/not a module/, fn -> module!(FakeModule) end
    end
  end

  describe "&module?/1" do
    test "is true" do
      assert module?(MaximumJank) == true
      assert module?(:gen_tcp) == true
    end

    test "is false" do
      assert module?(FakeModule) == false
      assert module?(123) == false
      assert module?(%{}) == false
      assert module?({1,2,3}) == false
    end
  end
end
