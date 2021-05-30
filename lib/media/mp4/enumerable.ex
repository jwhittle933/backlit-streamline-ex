defimpl Enumerable, for: Streamline.Media.MP4 do
  alias Streamline.Result
  alias Streamline.Media.MP4

  @doc """
  `count` returns the total box count

  TODO: from the docs
  `On the other hand, the count/1 function in this protocol should be implemented whenever
  you can count the number of elements in the collection without traversing it.`
  """
  def count(%MP4{ size: s } = m) do
    m
    |> MP4.Recurse.recurse(fn (_box, count) -> count + 1 end, 0)
    |> Result.wrap()
  end

  def member?(mp4, other) do
    MP4.find(mp4, other)
    |> case do
         { :ok, _ } -> Result.wrap(true)
         _ -> Result.wrap(false)
       end
  end

  def slice(mp4) do
    mp4
  end

  def reduce(%MP4{ children: [] }, acc, _fun), do: acc
  def reduce(%MP4{ children: nil }, acc, _fun), do: acc
  def reduce(%MP4{ children: _ } = m, acc, fun), do: MP4.recurse(m, fun, acc)
end
