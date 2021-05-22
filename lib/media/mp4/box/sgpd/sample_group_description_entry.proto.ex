defprotocol Streamline.Media.MP4.Box.Sgpd.SampleGroupDescriptionEntry do
  @moduledoc """
  `SampleGroupDescriptionEntry` protocol
  """
  alias __MODULE__

  @spec type(SampleGroupDescriptionEntry.t()) :: String.t()
  def type(sample)

  @doc """
  extended ->
    VisualSampleGroupEntry
      extended ->
        VisualRollRecoveryEntry('roll')
        AlternativeStartupEntry('alst')
        VisualRandomAccessEntry('rap ')
        TemporalLevelEntry('tele')

    AudioSampleGroupEntry
      extended ->
        AudioRollRecoveryEntry('roll')
        AudioPreRollEntry('prol')

    HintSampleGroupEntry

    SubtitleSampleGroupEntry

    TextSampleGroupEntry
  """
end

defmodule Streamline.Media.MP4.Box.Sample do
  @moduledoc """
  Sample
  """
end
