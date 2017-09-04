defmodule MaximumJank do
  @moduledoc """
  Documentation for MaximumJank.
  """

  @doc """
  Returns `arg` if it's a module, and raises a `RuntimeError  ` for anything else.
  """
  @spec module!(any()) :: module()
  def module!(arg) do
    if module?(arg) do
      arg
    else
      raise "not a module: #{inspect(arg)}"
    end
  end

  @doc """
  Returns `true` if argument is a module, and `false` for anything else.
  """
  @spec module?(any()) :: boolean()
  def module?(arg) do
    arg.module_info()[:module] == Module.concat([arg])
  rescue
    _ -> false
  end
end
