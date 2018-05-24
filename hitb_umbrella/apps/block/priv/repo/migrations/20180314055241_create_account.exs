defmodule Block.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:account) do
      add :username,           :string #用户名
      add :u_username,         :string
      add :isDelegate,         :integer #是否委托人
      add :u_isDelegate,       :integer
      add :secondSignature,    :integer
      add :u_secondSignature,  :integer
      add :address,            :string
      add :publicKey,          :string
      add :secondPublicKey,    :string
      add :balance,            :integer
      add :u_balance,          :integer
      add :vote,               :integer
      add :rate,               :integer
      add :delegates,          :string
      add :u_delegates,        :string
      add :multisignatures,    :string
      add :u_multisignatures,  :string
      add :multimin,           :integer
      add :u_multimin,         :integer
      add :multilifetime,      :integer
      add :u_multilifetime,    :integer
      add :blockId,            :string
      add :nameexist,          :boolean, default: false
      add :u_nameexist,        :boolean, default: false
      add :producedblocks,     :integer
      add :missedblocks,       :integer
      add :fees,               :integer
      add :rewards,            :integer
      add :lockHeight,         :integer
      timestamps()
    end
  end

end
