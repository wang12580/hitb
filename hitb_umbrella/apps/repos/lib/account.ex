defmodule Repos.Account do
  @moduledoc """
  Represents a account in a block chain
  """
  @type block :: %Repos.Account{
    index:              integer,
    username:           String.t,
    u_username:         String.t,
    isDelegate:         integer,
    u_isDelegate:       integer,
    secondSignature:    integer,
    u_secondSignature:  integer,
    address:            String.t,
    publicKey:          String.t,
    secondPublicKey:    String.t,
    balance:            integer,
    u_balance:          integer,
    vote:               integer,
    rate:               integer,
    delegates:          String.t,
    u_delegates:        String.t,
    multisignatures:    String.t,
    u_multisignatures:  String.t,
    multimin:           integer,
    u_multimin:         integer,
    multilifetime:      integer,
    u_multilifetime:    integer,
    blockId:            String.t,
    nameexist:          Boolen,
    u_nameexist:        Boolen,
    producedblocks:     integer,
    missedblocks:       integer,
    fees:               integer,
    rewards:            integer,
    lockHeight:         integer
  }
  @fields [:index, :username, :u_username, :isDelegate, :u_isDelegate, :secondSignature,
  :u_secondSignature, :address, :publicKey, :secondPublicKey, :balance, :u_balance, :vote,
  :rate, :delegates, :u_delegates, :multisignatures, :u_multisignatures, :multimin, :u_multimin,
  :multilifetime, :u_multilifetime, :blockId, :nameexist, :u_nameexist, :producedblocks,
  :missedblocks, :fees, :rewards, :lockHeight]
  @enforce_keys @fields
  defstruct     @fields
end
