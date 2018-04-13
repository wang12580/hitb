defmodule Repos.Peer do
  @moduledoc """
  Represents a block in a block chain
  """
  @type block :: %Repos.Peer{
    host:        String.t,
    port:        String.t,
    connect:     Boolen
  }
  @fields [:host, :port, :connect]
  @enforce_keys @fields
  defstruct     @fields
end
