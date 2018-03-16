defmodule Repos.Transaction do
  @moduledoc """
  Represents a block in a block chain
  """
  @type block :: %Repos.Transaction{
    id:                   integer,
    height:               integer,
    blockId:              String.t,
    type:                 integer,
    timestamp:            integer,
    senderPublicKey:      String.t,
    requesterPublicKey:   String.t,
    senderId:             String.t,
    recipientId:          String.t,
    amount:               integer,
    fee:                  integer,
    signature:            String.t,
    signSignature:        String.t,
    asset:                Map,
    args:                 Tuple,
    message:              String.t
  }
  @fields [:id, :height, :blockId, :type, :timestamp, :senderPublicKey, :requesterPublicKey,
  :senderId, :recipientId, :amount, :fee, :signature, :signSignature, :asset, :args, :message]
  @enforce_keys @fields
  defstruct     @fields
end
