defmodule ScrapeLagou.Scrape.Position do
  import Ecto.Query
  alias Mongo

  @base_url "https://www.lagou.com/gongsi/searchPosition.json"
  @concurrency   4
  @headers    ["User-Agent": "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36 115Browser/6.0.3",
  "Cookie": "JSESSIONID=35E8DF270CB0A743300EBC31FCF159A4; _gat=1; Hm_lvt_4233e74dff0ae5bd0a3d81c6ccf756e6=1484732018,1485529729; Hm_lpvt_4233e74dff0ae5bd0a3d81c6ccf756e6=1486402181; _ga=GA1.2.1357815869.1486402181; user_trace_token=20170207012941-d77b1529-ec91-11e6-9c63-525400f775ce; LGSID=20170207012941-d77b182b-ec91-11e6-9c63-525400f775ce; PRE_UTM=; PRE_HOST=; PRE_SITE=https%3A%2F%2Fwww.lagou.com%2Fgongsi%2F6-5-33%2C28%2C47; PRE_LAND=https%3A%2F%2Fwww.lagou.com%2Fgongsi%2F6-5-25%2C33%2C28%2C47; LGRID=20170207012941-d77b19d9-ec91-11e6-9c63-525400f775ce; LGUID=20170207012941-d77b1a13-ec91-11e6-9c63-525400f775ce"]
  @request_options    [recv_timeout: 10_000, follow_redirect: false, max_redirect: 5, hackney: [:insecure]]



  def start do
    {:ok, conn} = Mongo.start_link(database: "node-crawler")
    # query = from p in ScrapeLagou.Company,
    # query = from p in ScrapeLagou.Company, where: is_nil(p.detailsJson),
    query = from p in ScrapeLagou.Company, where: not is_nil(p.positionJson),
            select: p.companyId
    ScrapeLagou.Repo.all(query)
    |> IO.inspect
    |> loop_companies(conn)
  end

  def loop_companies([head | tail], conn) do
    fetch_company(head, conn)
    loop_companies(tail, conn)
  end
  def loop_companies([], _conn), do: []

  def fetch_company(id, page \\ 1, conn) do
    HTTPoison.start
    options = Keyword.put_new(@request_options, :params, %{companyId: id, pageNo: page})
    Process.sleep(1000)
    case HTTPoison.get(@base_url, @headers, options) do
      {:ok, response} ->
        case response.status_code do
          200 ->
            IO.inspect "2000000"
            IO.inspect Poison.Parser.parse!(response.body)

            %{"content" => %{"data" => %{"page" => %{"result" => positions, "totalCount" => totalCount}}}} = Poison.Parser.parse!(response.body)
            IO.inspect response.body
            IO.inspect "position size: "
            IO.inspect length(positions)
            if length(positions) > 0 do
              Mongo.insert_many(conn, "position", positions)
              update_company(id, :positionJson, Poison.encode!(positions))
              # loop to next page
              if String.to_integer(totalCount) > 10 * page do
                fetch_company(id, page + 1, conn)
              end
            end

          _ ->
            IO.inspect "IP is been block!!"
        end
      {:error, _response} ->
        IO.inspect "BAD LINK 40x: #{id}"
        IO.inspect _response
      _ ->
        IO.inspect "BAD LINK 500: #{id}"
    end


  end

  def update_company(id, key, value) do
    company = ScrapeLagou.Repo.get_by!(ScrapeLagou.Company, companyId: id)
    company = Ecto.Changeset.change company, %{key => value}
    IO.inspect company
    case ScrapeLagou.Repo.update(company) do
      {:ok, struct} ->
        IO.inspect "updated!!!"
        IO.inspect struct
      {:error, changeset} ->
        IO.inspect "updated error..."
        IO.inspect changeset
    end
  end

end

