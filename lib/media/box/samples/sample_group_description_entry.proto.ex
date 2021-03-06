defprotocol Streamline.Media.MP4.Box.SampleGroupDescriptionEntry do
  @moduledoc """
  `SampleGroupDescriptionEntry` protocol
  """
  alias __MODULE__

  @spec type(t()) :: String.t()
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
