defmodule Streamline.Media.MP4.Box.Stbl do
  @moduledoc """
  `stbl` BMFF sample table box

  The sample table contains all the time and data indexing of the media samples
  in a track. Using the tables here, it is possible to locate samples in time,
  determine their type (e.g. I‐frame or not), and determine their size, container,
  and offset into that container.

  If the track that contains the Sample Table Box references no data, then the Sample
  Table Box does not need to contain any sub‐boxes (this is not a very useful media track).

  If the track that the Sample Table Box is contained in does reference data, then the
  following sub‐boxes are required: Sample Description, Sample Size, Sample To Chunk,
  and Chunk Offset. Further, the Sample Description Box shall contain at least one entry.
  A Sample Description Box is required because it contains the data reference index field
  which indicates which Data Reference Box to use to retrieve the media samples. Without the
  Sample Description, it is not possible to determine where the media samples are stored.
  The Sync Sample Box is optional. If the Sync Sample Box is not present, all samples are sync
  samples.
  """
  alias __MODULE__
  alias Streamline.Media.MP4.Box
  alias Box.Info

  @type children :: list(any())
  @type t() :: %Stbl {
                 info: Info.t(),
                 children: children()
               }

  defstruct [info: nil, children: []]

  @spec write(Info.t(), iodata()) :: t()
  def write(%Info{} = i, <<data :: binary>>) do
    data
    |> Box.read()
    |> (&%Stbl{info: i, children: &1}).()
  end
end
