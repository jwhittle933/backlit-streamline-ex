defmodule Streamline.Media.MP4.Box.Sample.Audio do
  @moduledoc """
  `AudioSampleEntry`
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.{ Info, Sample, Srat }

  @type children :: [term()]
  @type t() :: %Audio{
                 sample: Sample.t(),
                 entry_version: Binary.u16(),
                 reserved: Binary.u64(),
                 channel_count: Binary.u16(),
                 sample_size: Binary.u16(),
                 predefined: Binary.u16(),
                 reserved2: Binary.u16(),
                 sample_rate: Binary.u32(),
                 #                 sampling_rate_box: Srat.t(),
                 #                 channel_layout: %{ },
                 #                 down_mix_instructions: [%{ }],
                 #                 drc_coefficients_basic: [%{ }],
                 #                 drc_instructions_basic: [%{ }],
                 #                 drc_coefficients_uni_drc: [%{ }],
                 #                 drc_instructions_uni_drc: [%{ }],
                 children: children()
               }

  defstruct [
    sample: nil,
    entry_version: 0,
    reserved: 0,
    channel_count: 2,
    sample_size: 16,
    predefined: 0,
    reserved2: 0,
    sample_rate: 0,
    #    sampling_rate_box: nil,
    #    channel_layout: %{ },
    #    down_mix_instructions: [],
    #    drc_coefficients_basic: [],
    #    drc_instructions_basic: [],
    #    drc_coefficients_uni_drc: [],
    #    drc_instructions_uni_drc: [],
    children: []
  ]

  def write(<< data :: binary >>) do
    data
    |> Sample.write()
    |> write_self()
  end

  @doc """
  `write_self` reads from the binary stream into %Audio{}

  Audio sample child boxes often need data from the
  Audio sample, so `write` uses %Info{context: %{...}}
  to pass information down
  """
  def write_self(
        {
          %Sample { } = s,
          <<
            _ :: size(64),
            channel_count :: size(16),
            sample_size :: size(16),
            _pre_def :: size(16),
            _res :: size(16),
            sample_rate :: size(32),
            rest :: binary
          >>
        }
      ) do
    {
      %Audio{
        sample: s,
        entry_version: 0,
        channel_count: channel_count,
        sample_size: sample_size,
        sample_rate: sample_rate
      },
      rest
    }
  end

  def write_self(
        {
          %Sample { } = s,
          <<
            1 :: size(16),
            _ :: size(48),
            channel_count :: size(16),
            sample_size :: size(16),
            _pre_def :: size(16),
            _res :: size(16),
            sample_rate :: size(32),
            rest :: binary
          >>
        }
      ) do
    {
      %Audio{
        sample: s,
        entry_version: 1,
        channel_count: channel_count,
        sample_size: sample_size,
        sample_rate: sample_rate
      },
      rest
    }
  end
end
