defmodule Streamline.Internal.Interceptor do
  @moduledoc """
  `Interceptor` module for pausing execution

  Internal use only: intended for debugging
  and spying on internal state during execution
  """

  def intercept_if(condition, subject) do
    with "true" <- System.get_env("DEBUG"),
         true <- condition do
      # print the subject
    end
  end

  def on(), do: System.put_env("DEBUG", "true")
  def off(), do: System.put_env("DEBUG", "false")
end
