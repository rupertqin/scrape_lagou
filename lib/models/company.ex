defmodule ScrapeLagou.Company do
  use Ecto.Schema
  # import Ecto.Changeset

	schema "company" do
		field :companyId,           :integer
		field :companyFullName,     :string
		field :companyShortName,    :string
		field :companyLogo,         :string
		field :city,                :string
		field :industryField,       :string
		field :companyFeatures,     :string
		field :financeStage,        :string
		field :interviewRemarkNum,  :integer
		field :positionNum,         :integer
		field :processRate,         :integer
		field :approve,             :integer
		field :countryScore,        :integer
		field :cityScore,           :integer
	end

  # @required_fields ~w(title url issue)
  # @optional_fields ~w()

  # def changeset(article, params \\ %{}) do
  #   article
  #   |> cast(params, ~w(html ps title url issue)a)
  #   |> validate_required([:title, :url])
  # end
end
