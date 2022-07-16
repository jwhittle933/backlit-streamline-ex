defmodule Streamline.Media.HLS do
  @moduledoc """
  `HLS` Module for Media Stream Segmentation
  """

  @header "#EXTM3U"
  @version "#EXT-X-VERSION:"
  @media_sequence "#EXT-X-MEDIA-SEQUENCE:"
  @discontinuity_sequence "#EXT-X-DISCONTINUITY-SEQUENCE:"
  @discontinuity "#EXT-X-DISCONTINUITY:"
  @playlist_type "#EXT-X-PLAYLIST-TYPE:"
  @duration "#EXT-X-TARGETDURATION:"
  @independent_segments "#EXT-X-INDEPENDENT-SEGMENTS:"
  @map "#EXT-X-MAP:URI"
  @inf "#EXTINF:"
  @tail "#EXT-X-ENDLIST"


  @playlist_types ["VOD", "EVENT"]
end
