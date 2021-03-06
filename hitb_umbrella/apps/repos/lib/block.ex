defmodule Repos.Block do
  @moduledoc """
  Represents a block in a block chain
  """
  @type block :: %Repos.Block{
    index:         integer,
    previous_hash: String.t,
    timestamp:     integer,
    data:          String.t,
    hash:          String.t
  }
  @fields [:index, :previous_hash, :timestamp, :data, :hash]
  @enforce_keys @fields
  defstruct     @fields
end
