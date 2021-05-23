defmodule Streamline.Media.MP4.Recurse do
  @moduledoc """
  Module `recurse` for recursively reading MP4
  """
  alias Streamline.Result
  alias Streamline.Media.MP4

  def all_boxes(%MP4{children: []}, _key), do: Result.wrap_err(:no_children)
  def all_boxes(%MP4{children: c}, _key) do
    #
  end
end
