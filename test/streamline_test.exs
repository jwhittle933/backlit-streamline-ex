defmodule StreamlineTest do
  use ExUnit.Case
  doctest Streamline

  test "greets the world" do
    assert Streamline.streamline() == :streamline
  end
end
