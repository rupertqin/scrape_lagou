defmodule ScrapeLagou.Scrape.Company do

  @concurrency   4
  @base_url   "https://www.lagou.com/gongsi/"
  @headers    ["User-Agent": "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36 115Browser/6.0.3",
  "Cookie": "JSESSIONID=35E8DF270CB0A743300EBC31FCF159A4; _gat=1; Hm_lvt_4233e74dff0ae5bd0a3d81c6ccf756e6=1484732018,1485529729; Hm_lpvt_4233e74dff0ae5bd0a3d81c6ccf756e6=1486402181; _ga=GA1.2.1357815869.1486402181; user_trace_token=20170207012941-d77b1529-ec91-11e6-9c63-525400f775ce; LGSID=20170207012941-d77b182b-ec91-11e6-9c63-525400f775ce; PRE_UTM=; PRE_HOST=; PRE_SITE=https%3A%2F%2Fwww.lagou.com%2Fgongsi%2F6-5-33%2C28%2C47; PRE_LAND=https%3A%2F%2Fwww.lagou.com%2Fgongsi%2F6-5-25%2C33%2C28%2C47; LGRID=20170207012941-d77b19d9-ec91-11e6-9c63-525400f775ce; LGUID=20170207012941-d77b1a13-ec91-11e6-9c63-525400f775ce"]
  @request_options    [recv_timeout: 10_000, follow_redirect: false, max_redirect: 5, hackney: [:insecure]]


  def start do
    IO.inspect System.argv()
    cities = gain_cities()
    loop_company_list(cities)
  end

  def gain_cities do
    {:ok, data} = File.read("./data/cities.json")
    %{"cities" => cities} = Poison.Parser.parse!(data)
    cities
  end

  def loop_company_list([head | tail]) do
    fetch_company(head, 1)
    loop_company_list(tail)
  end

  def loop_company_list([]), do: []

  def fetch_company(city_obj, page \\ 1) do
    HTTPoison.start
    options = Keyword.put_new(@request_options, :params, %{pn: page})
    id = city_obj["id"]
    Process.sleep(2000)
    case HTTPoison.get(@base_url<>"#{id}-0-0.json", @headers, options) do
      {:ok, response} ->
        case response.status_code do
          200 ->
            %{"result" => companies} = Poison.Parser.parse!(response.body)
            insert_companies(companies)
            if length(companies) == 16 do
              fetch_company(city_obj, page + 1)
            end
          _ ->
            IO.inspect "IP is been block!!"
            "no match"
        end
      {:error, _response} ->
        IO.inspect "BAD LINK 40x: #{id}, page: #{page}"
        IO.inspect _response
      _ ->
        IO.inspect "BAD LINK 500: #{id}, page: #{page}"
    end

  end

  def insert_companies(companies) do
    for company <- companies do
      # check if exist
      origin_company = ScrapeLagou.Repo.get_by(ScrapeLagou.Company, companyId: company["companyId"])
      if !origin_company do
        ScrapeLagou.Repo.insert %ScrapeLagou.Company{
          companyId: company["companyId"],
          companyFullName: company["companyFullName"],
          companyShortName: company["companyShortName"],
          companyLogo: company["companyLogo"],
          city: company["city"],
          industryField: company["industryField"],
          companyFeatures: company["companyFeatures"],
          financeStage: company["financeStage"],
          interviewRemarkNum: company["interviewRemarkNum"],
          positionNum: company["positionNum"],
          processRate: company["processRate"],
          approve: company["approve"],
          countryScore: company["countryScore"],
          cityScore: company["cityScore"]
        }
      end
    end
  end

end
