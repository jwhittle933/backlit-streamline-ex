defmodule Streamline.Media.MP4.Box.Urn do
  @moduledoc """
  `urn ` BMFF Box
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Urn {
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               # `name` is a URN, and is required
               name: String.t(),
               # `location` is a URL, and is optional
               location: String.t()
             }

  defstruct [:info, :version, :flags, :name, :location]

  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          rest :: binary
        >>
      ) do
    %Urn{info: i, version: v, flags: flags}
    |> write_name_location(rest)
  end

  @spec write_name_location(t(), iodata()) :: t()
  defp write_name_location(%Urn{} = u, <<data :: binary>>) do
    data
    |> :binary.bin_to_list()
    |> Enum.find_index(fn x -> x == 0 end)
    |> (&Enum.split(data, &1)).()
    |> (fn [name, [_ | location]] -> {:binary.list_to_bin(name), :binary.list_to_bin(location)} end).()
    |> (fn {name, location} ->
      %Urn{u | name: name, location: location}
    end).()
  end
end
