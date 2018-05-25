defmodule Block.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Block.Transaction


  schema "transaction" do
    filed :transaction_id,      :integer
    filed :height,              :integer
    filed :blockId,             :string
    filed :type,                :integer
    filed :timestamp,           :integer
    filed :datetime,            :string
    filed :senderPublicKey,     :string
    filed :requesterPublicKey,  :string
    filed :senderId,            :string
    filed :recipientId,         :string
    filed :amount,              :integer
    filed :fee,                 :integer
    filed :signature,           :string
    filed :signSignature,       :string
    filed :asset,               {:array, :string}
    filed :args,                {:array, :string}
    filed :message,             :string
    timestamps()
  end

  @doc false
  def changeset(%Transaction{} = transaction, attrs) do
    transaction
    |> cast(attrs, [:transaction_id, :height, :blockId, :type, :timestamp, :datetime, :senderPublicKey,  :requesterPublicKey, :senderId, :recipientId, :amount, :fee, :signature, :signSignature, :asset, :args, :message])
    |> validate_required([:transaction_id, :height, :blockId, :type, :timestamp, :datetime, :senderPublicKey,  :requesterPublicKey, :senderId, :recipientId, :amount, :fee, :signature, :signSignature, :asset, :args, :message])
  end
end
