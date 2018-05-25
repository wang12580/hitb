defmodule Block.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias Block.Account

  schema "account" do
    field :username,           :string #用户名
    field :u_username,         :string
    field :isDelegate,         :integer #是否委托人
    field :u_isDelegate,       :integer
    field :secondSignature,    :integer
    field :u_secondSignature,  :integer
    field :address,            :string
    field :publicKey,          :string
    field :secondPublicKey,    :string
    field :balance,            :integer
    field :u_balance,          :integer
    field :vote,               :integer
    field :rate,               :integer
    field :delegates,          :string
    field :u_delegates,        :string
    field :multisignatures,    :string
    field :u_multisignatures,  :string
    field :multimin,           :integer
    field :u_multimin,         :integer
    field :multilifetime,      :integer
    field :u_multilifetime,    :integer
    field :blockId,            :string
    field :nameexist,          :boolean, default: false
    field :u_nameexist,        :boolean, default: false
    field :producedblocks,     :integer
    field :missedblocks,       :integer
    field :fees,               :integer
    field :rewards,            :integer
    field :lockHeight,         :integer
    timestamps()
  end

  @doc false
  def changeset(%Account{} = account, attrs) do
    account
    |> cast(attrs, [:username,:u_username, :isDelegate, :u_isDelegate, :secondSignature, :u_secondSignature, :address, :publicKey, :secondPublicKey, :balance, :u_balance, :vote, :rate, :delegates,  :u_delegates, :multisignatures, :u_multisignatures, :multimin, :u_multimin, :multilifetime, :u_multilifetime, :blockId, :nameexist, :u_nameexist, :producedblocks, :missedblocks, :fees, :rewards, :lockHeight])
    |> validate_required([:username,:u_username, :isDelegate, :u_isDelegate, :secondSignature, :u_secondSignature, :address, :publicKey, :secondPublicKey, :balance, :u_balance, :vote, :rate, :delegates,  :u_delegates, :multisignatures, :u_multisignatures, :multimin, :u_multimin, :multilifetime, :u_multilifetime, :blockId, :nameexist, :u_nameexist, :producedblocks, :missedblocks, :fees, :rewards, :lockHeight])
  end
end
