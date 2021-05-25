defimpl Enumerable, for: Streamline.Media.MP4 do
  alias Streamline.Media.MP4

  def count(%MP4{size: s}), do: s

  def member?(mp4, other) do
    with {:ok, _} <- MP4.Find.find(mp4, other) do
      true
    else
      _ -> false
    end
  end

  def slice(mp4) do
    mp4
  end

  def reduce(%MP4{children: []}, acc, _fun), do: acc
  def reduce(%MP4{children: nil}, acc, _fun), do: acc
  def reduce(%MP4{children: _} = m, acc, fun), do: MP4.recurse(m, fun, acc)
end
