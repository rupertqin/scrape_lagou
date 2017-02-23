defmodule ScrapeLagou.Repo.Migrations.CreateAddress do
  use Ecto.Migration

  def change do
    create table(:address) do
      add :companyId, :integer
      add :companyId, :integer
    end

  end
end
