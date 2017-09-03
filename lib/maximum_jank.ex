defmodule MaximumJank do
  @moduledoc """
  Documentation for MaximumJank.
  """

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
