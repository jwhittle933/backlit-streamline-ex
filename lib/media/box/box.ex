defmodule Streamline.Media.MP4.Box do
  @moduledoc """
  Box module parses box data and distributes it to the
  appropriate module for writing
  """
  alias __MODULE__
  alias Streamline.Binary
  alias Streamline.Result
  alias Streamline.Media.MP4.Box.{ Info, BoxType }

  @type t :: term()
  @type children :: [term()]
  @type flags :: << _ :: 24 >>
  @type base :: %{ }
  @type fullbox :: %{
                     version: Binary.u8(),
                     flags: flags()
                   }

  defmacro __using__(_) do
    quote do
      alias  __MODULE__
      alias Streamline.Media.MP4.Box
      alias Streamline.Media.MP4.Box.Info
    end
  end

  @doc """
  `defextends` macro for Box meta programming
  """
  defmacro defextends(module, do: block) do
    quote do
      IO.puts("defextends/1 not implemented")
    end
  end

  @behaviour Streamline.Media.MP4.Box.Boxed

  defprotocol Typeable do
    @spec type(t) :: String.t()
    def type(box)
  end

  defprotocol Writeable do
    @spec write(t, iodata()) :: t
    def write(box, src)
  end

  defprotocol Infoable do
    @spec info(t) :: Info.t()
    def info(box)
  end

  ####### Behaviors ######
  # Each behavior below should operate on a box
  # that implements the protocols above
  def type(box) do
    Box.Typeable.type(box)
  end

  def write(box, iodata) do
    Box.Writeable.write(box, iodata)
  end

  def stringify(box) do
    String.Chars.to_string(box)
  end

  def info(box) do
    Box.Infoable.info(box)
  end

  @spec box_module(String.t()) :: module()
  def box_module(box_name) do
    box_name
    |> String.trim()
    |> :string.titlecase()
    |> (&:"Elixir.Streamline.Media.MP4.Box.#{&1}").()
  end

  @spec write_box(String.t(), iodata()) :: module()
  def write_box(%Info{ type: t } = i, data) do
    t
    |> box_module()
    |> apply(:write, [i, data])
  end

  @spec read(iodata, [term()], integer()) :: [term()]
  def read(data, acc \\ [], offset \\ 0)
  def read(
        <<
          size :: size(32) - unsigned - big - integer,
          name :: bytes - size(4),
          data :: binary
        >>,
        acc,
        offset
      ) do
    { box, rest } = box_from(data, size - 8)

    name
    |> BoxType.from()
    |> Info.from(size, offset)
    |> write_box(box)
    |> (&read(rest, acc ++ [{ :"#{name}", &1 }], size + offset)).()
  end

  def read("", acc, _offset), do: acc


  defmodule NoChildrenException do
    defexception [message: "Box contains no children"]
  end

  @doc """
  `first` retrieves the first child box contained in a parent
  """
  @spec first(term()) :: Result.t()
  def first(%{ children: nil }), do: Result.wrap_err(:nil_children)
  def first(%{ children: [] }), do: Result.wrap_err(:empty_children)
  def first(%{ children: [{ _, child } | _] }), do: Result.wrap(child)
  def first(_), do: Result.wrap_err(:no_child_box)

  @doc """
  `first!` retrieves the first child box contained in a parent
  """
  @spec first!(term()) :: Result.t()
  def first!(%{ children: nil }), do: raise(Box.NoChildrenException, message: "Nil children")
  def first!(%{ children: [] }), do: raise(Box.NoChildrenException, message: "Empty children")
  def first!(%{ children: [{ _, child } | _] }), do: child
  def first!(_), do: raise(Box.NoChildrenException, message: "Box does not contain children")

  defp box_from(<< data :: binary >>, n_bytes) do
    << box :: bytes - size(n_bytes), rest :: binary >> = data
    { box, rest }
  end
end
