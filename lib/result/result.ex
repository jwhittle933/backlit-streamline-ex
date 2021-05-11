defmodule Streamline.Result do
  @moduledoc """
  Streamline Result Wrapper for processes that may error
  """

  defmodule ResultException do
    defexception [:message]
  end

  @type t() :: {:ok | :error, term()}

  @spec ok(term()) :: t
  def ok(arg), do: {:ok, arg}

  @spec error(term()) :: t
  def error(arg), do: {:error, arg}

  @spec unwrap(t) :: term()
  def unwrap({:ok, arg}), do: arg

  def unwrap({:error, arg}), do: arg

  @spec expect(t, String.t()) :: t
  def expect({:ok, arg}, msg), do: arg

  def expect({:error, arg}, msg) do
    raise Streamline.Result.ResultException, message: msg
  end
end
