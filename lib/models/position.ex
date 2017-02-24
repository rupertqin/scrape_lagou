defmodule ScrapeLagou.Position do
  use Ecto.Schema

  @primary_key false
	schema "position" do
    field :companyId, :integer, primary_key: true
    field :positionId, :integer, primary_key: true
    field :jobNature, :string
    field :financeStage, :string
    field :companyName, :string
    field :companyFullName, :string
    field :companySize, :string
    field :industryField, :string
    field :positionName, :string
    field :city, :string
    field :createTime, :string
    field :salary, :string
    field :workYear, :string
    field :education, :string
    field :positionAdvantage, :string
    field :companyLabelList, {:array, :string}
    field :userId, :integer
    field :companyLogo, :string
    field :haveDeliver, :boolean
    field :score, :integer
    field :adWord, :integer
    field :adTimes, :integer
    field :adBeforeDetailPV, :integer
    field :adAfterDetailPV, :integer
    field :adBeforeReceivedCount, :integer
    field :adAfterReceivedCount, :integer
    field :isCalcScore, :boolean
    field :searchScore, :float
    field :district, :string
	end

  # @required_fields ~w(title url issue)
  # @optional_fields ~w()

  # def changeset(article, params \\ %{}) do
  #   article
  #   |> cast(params, ~w(html ps title url issue)a)
  #   |> validate_required([:title, :url])
  # end
end
