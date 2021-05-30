defmodule Streamline.Media.MP4.Box.Sample.Audio do
  @moduledoc """
  `AudioSampleEntry`
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info
  alias Box.Srat

  @type children :: [term()]
  @type t() :: %Audio{
                 entry_version: Binary.u16(),
                 coding_name: String.t(),
                 reserved: Binary.u64(),
                 channel_count: Binary.u16(),
                 sample_size: Binary.u16(),
                 predefined: Binary.u16(),
                 reserved2: Binary.u16(),
                 sample_rate: Binary.u32(),
                 sampling_rate_box: Srat.t(),
                 channel_layout: %{ },
                 down_mix_instructions: [%{ }],
                 drc_coefficients_basic: [%{ }],
                 drc_instructions_basic: [%{ }],
                 drc_coefficients_uni_drc: [%{ }],
                 drc_instructions_uni_drc: [%{ }],
                 children: children()
               }

  defstruct [
    entry_version: 0,
    reserved: 0,
    coding_name: "",
    channel_count: 2,
    sample_size: 16,
    predefined: 0,
    reserved2: 0,
    sample_rate: 0,
    sampling_rate_box: nil,
    channel_layout: %{ },
    down_mix_instructions: [],
    drc_coefficients_basic: [],
    drc_instructions_basic: [],
    drc_coefficients_uni_drc: [],
    drc_instructions_uni_drc: [],
    children: []
  ]

  def write(%Info{ type: t } = i, << data :: binary >>) do
    %Audio{ coding_name: t }
  end
end
