defmodule ScrapeLagou.Repo.Migrations.CreatePosition do
  use Ecto.Migration

  def change do
    create table(:position, primary_key: false) do
      add :companyId, :integer, primary_key: true
      add :positionId, :integer, primary_key: true
      add :jobNature, :string
      add :financeStage, :string
      add :companyName, :string
      add :companyFullName, :string
      add :companySize, :string
      add :industryField, :string
      add :positionName, :string
      add :city, :string
      add :createTime, :string
      add :salary, :string
      add :workYear, :string
      add :education, :string
      add :positionAdvantage, :string
      add :companyLabelList, {:array, :string}
      add :userId, :integer
      add :companyLogo, :string
      add :haveDeliver, :boolean
      add :score, :integer
      add :adWord, :integer
      add :adTimes, :integer
      add :adBeforeDetailPV, :integer
      add :adAfterDetailPV, :integer
      add :adBeforeReceivedCount, :integer
      add :adAfterReceivedCount, :integer
      add :isCalcScore, :boolean
      add :searchScore, :float
      add :district, :string
    end

    create unique_index(:position, [:positionId], name: :positionId_key)

  end
end
