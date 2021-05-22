defmodule Streamline.Media.MP4.Box.Tsel do
  @moduledoc """
  `tsel` Track Selection

  A typical presentation stored in a file contains one alternate group per media type: one for video,
  one for audio, etc. Such a file may include several video tracks, although, at any point in time,
  only one of them should be played or streamed. This is achieved by assigning all video tracks to the
  same alternate group. (See subclause 8.3.2 for the definition of alternate groups.)

  All tracks in an alternate group are candidates for media selection, but it may not make sense to
  switch between some of those tracks during a session. One may for instance allow switching between
  video tracks at different bitrates and keep frame size but not allow switching between tracks of
  different frame size. In the same manner it may be desirable to enable selection – but not switching –
  between tracks of different video codecs or different audio languages.

  The distinction between tracks for selection and switching is addressed by assigning tracks to switch
  groups in addition to alternate groups. One alternate group may contain one or more switch groups.
  All tracks in an alternate group are candidates for media selection, while tracks in a switch group
  are also available for switching during a session. Different switch groups represent different operation
  points, such as different frame size, high/low quality, etc.

  For the case of non‐scalable bitstreams, several tracks may be included in a switch group. The same also
  applies to non‐layered scalable bitstreams, such as traditional AVC streams.

  By labelling tracks with attributes it is possible to characterize them. Each track can be labelled with a
  list of attributes which can be used to describe tracks in a particular switch group or differentiate tracks
  that belong to different switch groups.
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type t :: %Tsel{
               info: Info.t(),
               # `version` is an integer that specifies the version of this box
               # (0 or 1 in this specification)
               version: Binary.u8(),
               # `flags` is a map of flags
               flags: <<_ :: 24>>,
               switch_group: Binary.u32(),
               attribute_list: [String.t()]
             }

  defstruct [
    info: nil,
    version: 0,
    flags: nil,
    switch_group: 0,
    attribute_list: []
  ]

  @spec write(Info.t(), iodata()) :: t()
  def write(
        %Info{} = i,
        <<
          v :: 8,
          flags :: bitstring - size(24),
          switch_group :: size(32) - unsigned - big - integer,
          attributes :: binary
        >>
      ) do
    %Tsel{
      info: i,
      version: v,
      flags: flags
    }
    |> write_attributes(attributes)
  end

  defp write_attributes(
         %Tsel{attribute_list: al} = t,
         <<
           attr :: bytes - size(4),
           attributes :: binary
         >>
       ) do
    %Tsel{t | attribute_list: al ++ [attr]}
    |> write_attributes(attributes)
  end

  defp write_attributes(%Tsel{} = t, ""), do: t
end
