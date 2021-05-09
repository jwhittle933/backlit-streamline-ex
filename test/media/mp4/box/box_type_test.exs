defmodule BoxTypeTest do
  use ExUnit.Case
  alias Streamline.Media.MP4.Box.BoxType
  doctest BoxType

  test "parses the name from the header" do
    header = <<102, 116, 121, 112, 1, 3, 4>>
    {name, rest} = BoxType.from(header)

    assert name == "ftyp"
    assert rest == <<1, 3, 4>>
  end

  test "invalid length" do
    header = <<102, 116>>
    {name, rest} = BoxType.from(header)

    assert name == "unknown"
    assert rest == <<102, 116>>
  end
end
