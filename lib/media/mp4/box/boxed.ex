defmodule Streamline.Media.MP4.Box.Boxed do
  @moduledoc """
  Boxed behavior module
  """
  alias Streamline.Media.MP4.Box.Info

  @callback type(term()) :: String.t()
  @callback write(term(), iodata()) :: term()
  @callback stringify(term()) :: String.t()
  @callback info(term()) :: Info.t()
end

defmodule Streamline.Media.MP4.Box.Boxed.Typed do
  @moduledoc """
  Typed behavior module
  """
  @callback type(term()) :: String.t()
end

defmodule Streamline.Media.MP4.Box.Boxed.Written do
  @moduledoc """
  Written behavior module
  """
  @callback write(term(), iodata()) :: term()
end

defmodule Streamline.Media.MP4.Box.Boxed.Stringified do
  @moduledoc """
  Stringified behavior module
  """
  @callback stringify(term()) :: String.t()
end

defmodule Streamline.Media.MP4.Box.Boxed.Infoed do
  @moduledoc """
  Infoed behavior module
  """
  alias Streamline.Media.MP4.Box.Info

  @callback info(term()) :: Info.t()
end
