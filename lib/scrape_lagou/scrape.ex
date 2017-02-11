defmodule ScrapeLagou.Scrape do
  use GenServer
  alias ScrapeLagou.Scrape.Company

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(:ok) do
    IO.inspect "always run..."
    start()
    {:ok, {%{}}}
  end

  def start do
    # IO.inspect System.argv()
    # type = List.first System.argv
    # case type do
    #   "company" ->
    #     Company.start()
    #   _ ->
    #     IO.inspect "no match"
    # end
  end
end
