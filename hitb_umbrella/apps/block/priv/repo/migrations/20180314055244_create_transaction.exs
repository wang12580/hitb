defmodule Block.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table(:transaction) do
      add :transaction_id,      :string
      add :height,              :integer
      add :blockId,             :string
      add :type,                :integer
      add :timestamp,           :integer
      add :datetime,            :string
      add :senderPublicKey,     :string
      add :requesterPublicKey,  :string
      add :senderId,            :string
      add :recipientId,         :string
      add :amount,              :integer
      add :fee,                 :integer
      add :signature,           :string
      add :signSignature,       :string
      add :asset,               {:array, :string}
      add :args,                {:array, :string}
      add :message,             :string
      timestamps()
    end
  end

end
