defmodule Streamline.Media.MP4.Box.Mvhd do
  @moduledoc false
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box.Info
  alias __MODULE__

  @type children :: list(any())
  @type t() :: %Mvhd{
                 info: Info.t(),
                 version: Binary.u8(),
                 flags: Binary.u32(),
                 creation_time: Binary.usize(),
                 modification_time: Binary.usize(),
                 timescale: Binary.u32(),
                 duration: Binary.u64(),
                 rate: Binary.u32(),
                 volume: Binary.u16(),
                 reserved: Binary.u16(),
                 reserved2: {Binary.u32(), Binary.u32()},
                 matrix: {
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32()
                 },
                 predefined: iodata(),
                 next_track_id: Binary.u32(),
                 raw: iodata()
               }

  defstruct [
    :info,
    :version,
    :flags,
    :creation_time,
    :modification_time,
    :timescale,
    :duration,
    :rate,
    :volume,
    :reserved,
    :reserved2,
    :matrix,
    :predefined,
    :next_track_id,
    :raw
  ]

  @spec write(Info.t(), iodata()) :: t()
  def write(%Info{} = i, <<data :: binary>>) do
    %Mvhd{info: i, raw: data}
  end
end
