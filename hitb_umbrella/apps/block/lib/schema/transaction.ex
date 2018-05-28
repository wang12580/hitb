defmodule Block.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Block.Transaction


  schema "transaction" do
    field :transaction_id,      :string
    field :height,              :integer
    field :blockId,             :string
    field :type,                :integer
    field :timestamp,           :integer
    field :datetime,            :string
    field :senderPublicKey,     :string
    field :requesterPublicKey,  :string
    field :senderId,            :string
    field :recipientId,         :string
    field :amount,              :integer
    field :fee,                 :integer
    field :signature,           :string
    field :signSignature,       :string
    field :asset,               {:array, :string}
    field :args,                {:array, :string}
    field :message,             :string
    timestamps()
  end

  @doc false
  def changeset(%Transaction{} = transaction, attrs) do
    transaction
    |> cast(attrs, [:transaction_id, :height, :blockId, :type, :timestamp, :datetime, :senderPublicKey,  :requesterPublicKey, :senderId, :recipientId, :amount, :fee, :signature, :signSignature, :asset, :args, :message])
    |> validate_required([:transaction_id, :height, :blockId, :type, :timestamp, :datetime, :senderPublicKey, :recipientId, :amount, :fee, :asset, :args, :message])
  end
end
