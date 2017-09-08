defmodule MaximumJank do
  @moduledoc """
  Documentation for MaximumJank.
  """

  @doc """
  TODO:  Come up w/ a non-lame way to document how awesome declaring `use MaximumJank` actually is; a good example is needed!
  """
  defmacro __using__(_) do
    # throws an error if used outside of a module
    if __CALLER__.module == nil do
      raise "cannot invoke 'use #{inspect(__MODULE__)}' outside module"
    end

    # concatenates caller's module w/ current module
    # example:  MyModule + __MODULE__ becomes MyModule.__MODULE__
    module = Module.concat([__CALLER__.module, __MODULE__])

    # checks to see if `use MaximumJank` has been called previously:
    # - this check is done by calling `module.using?`
    # - an `UndefinedFunctionError` means `use MaximumJank` has not been called
    # - `true` means it has not been called, and the in the rescue block is run
    try do
      module.using?()
    rescue
      _ in UndefinedFunctionError ->
        Kernel.defmodule(module) do
          @moduledoc false
          @doc false
          @spec using?() :: true
          def using?() do
            true
          end
        end
      error ->
        raise "this sould not happen: #{inspect(error)}"
    end

    quote do
    end
  end

  @doc """
  Takes a `%Macro.Env{}` struct, and returns the same struct, if the struct's module has declared `use MaximumJank`.  If the module is not using `MaximumJank`, a RuntimeError will be raised.

  ##Notes

  - For some examples, see the tests.
  - Refer to the docs for `&__using__/1` to understand why you'd use this function.
  """
  def __using__!(%Macro.Env{module: nil}) do
    inspected_func = inspected_func(__ENV__)
    raise "cannot invoke #{inspected_func} outside module"
  end

  def __using__!(%Macro.Env{}=env) do
    if __using__?(env) do
      env
    else
      module = inspect(__ENV__.module)
      inspected_func = inspected_func(__ENV__)
      raise "you must declare 'use #{module}' to invoke #{inspected_func}"
    end
  end

  @doc """
  Takes a `%Macro.Env{}` struct, and returns `true` the struct's module has declared `use MaximumJank`.  If the module is not using `MaximumJank`, it returns false.

  ## Notes

  - For some examples, see the tests.
  - Refer to the docs for `&__using__/1` to understand why you'd use this function.
  """
  def __using__?(%Macro.Env{module: nil}) do
    inspected_func = inspected_func(__ENV__)
    raise "cannot invoke #{inspected_func} outside module"
  end

  def __using__?(%Macro.Env{}=env) do
    module = Module.concat([env.module, MaximumJank])
    module.using?()
  rescue
    _ -> false
  end

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
  def module?(arg) when is_atom(arg) do
    arg.module_info()[:module] == arg
  rescue
    _ -> false
  end

  def module?(_), do: false

  ###########
  # Private #
  ###########

  defp inspected_func(%Macro.Env{}=env) do
    module = inspect(env.module)
    {function,arity} = env.function
    function2 = Atom.to_string(function)
    arity2 = Integer.to_string(arity)
    "&" <> module <> "." <> function2 <> "/" <> arity2
  end
end
