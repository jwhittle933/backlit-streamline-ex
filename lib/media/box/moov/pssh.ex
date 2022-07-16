defmodule Streamline.Media.MP4.Box.Pssh do
  @moduledoc """
  `pssh` Protection System Specific Header Box
  """
  use Streamline.Media.MP4.Box

  @type t :: %Pssh{
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: << _ :: 24 >>,
               # `system_id` specifies a UUID that uniquely identifies the content
               # protection system that this header belongs to.
               system_id: Binary.c128(),
               kid_count: Binary.u32(),
               kids: [%{ kid: non_neg_integer() }]
             }

  defstruct [info: nil, version: 0, flags: nil, system_id: 0, kid_count: 0, kids: []]

  def write(
        %Info{ } = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          system_id :: size(128),
          rest :: binary
        >>
      ) do
    %Pssh{
      info: i,
      version: v,
      flags: flags,
      system_id: system_id
    }
    |> write_kid_count(rest)
  end

  def write_kid_count(%Pssh{ version: v } = p, << kid_count :: size(32) - unsigned - big - integer, rest :: binary >>) when v > 0 do
    %Pssh{ p | kid_count: kid_count }
    |> write_kids(rest)
  end

  def write_kids_count(%Pssh{ } = p, << _ :: binary >>), do: p

  def write_kids(
        %Pssh{ kid_count: kc, kids: k } = p,
        <<
          kid :: size(128) - unsigned - big - integer,
          rest :: binary
        >>
      ) when length(k) < kc do
    %Pssh{ p | kids: k ++ [%{ kid: kid }] }
    |> write_kids(rest)
  end

  def write_kids(%Pssh{ } = p, _), do: p
end
