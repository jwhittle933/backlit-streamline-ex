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
                   Binary.i32(),
                 },
                 predefined: {
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32(),
                   Binary.i32()
                 },
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
  def write(
        %Info{} = i,
        <<
          v :: 8,
          flags :: 32,
          create :: 32,
          mod :: 32,
          timescale :: 32,
          duration :: 64,
          rate :: 32,
          volume :: 16,
          _ :: 16,
          _ :: 32 * 2,
          matrix :: 32 * 9,
          predefined :: 32 * 6,
          next :: 32,
        >> = data
      ) do
    %Mvhd{
      info: i,
      version: v,
      flags: flags,
      creation_time: create,
      modification_time: mod,
      timescale: timescale,
      duration: duration,
      rate: rate,
      volume: volume,
      next_track_id: next,
      raw: data
    }
    |> write_matrix(matrix)
    |> write_predefined(matrix)
  end

  def write(
        %Info{} = i,
        <<
          v :: 8,
          flags :: 32,
          create :: 64,
          mod :: 64,
          timescale :: 32,
          duration :: 64,
          rate :: 32,
          volume :: 16,
          _ :: 16,
          _ :: 32 * 2,
          matrix :: 32 * 9,
          predefined :: 32 * 6,
          next :: 32,
        >> = data
      ) do
    %Mvhd{
      info: i,
      version: v,
      flags: flags,
      creation_time: create,
      modification_time: mod,
      timescale: timescale,
      duration: duration,
      rate: rate,
      volume: volume,
      next_track_id: next,
      raw: data
    }
    |> write_matrix(matrix)
    |> write_predefined(matrix)
  end

  defp write_matrix(%Mvhd{} = m, <<m0 :: 32, m1 :: 32, m2 :: 32, m3 :: 32, m4 :: 32, m5 :: 32, m6 :: 32, m7 :: 32, m8 :: 32>>) do
    %Mvhd{m | matrix: {m0, m1, m2, m3, m4, m5, m6, m7, m8}}
  end

  defp write_predefined(%Mvhd{} = m, <<m0 :: 32, m1 :: 32, m2 :: 32, m3 :: 32, m4 :: 32, m5 :: 32>>) do
    %Mvhd{m | predefined: {m0, m1, m2, m3, m4, m5}}
  end
end
