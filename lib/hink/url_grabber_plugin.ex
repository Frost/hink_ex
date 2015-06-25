defmodule Hink.UrlGrabberPlugin do
  use GenServer

  def start_link(client),
    do: GenServer.start_link(__MODULE__, [client])

  def init([client]) do
    ExIrc.Client.add_handler(client, self)
    {:ok, client}
  end

  def handle_info({:received, msg, sender, channel}, client) do
    grab_url_titles(msg)
    |> Enum.map(fn {title, url} ->
      reply = sender <> ": " <> title <> " - " <> url
      ExIrc.Client.msg(client, :privmsg, channel, reply)
    end)
    {:noreply, client}
  end

  def handle_info(_msg, client), do: {:noreply, client}

  defp grab_url_titles(msg) do
    msg
    |> extract_urls
    |> Enum.map(fn url ->
      Task.async(fn ->
        {extract_title(url), url}
      end)
    end)
    |> Enum.map(&Task.await/1)
  end

  defp extract_urls(msg) do
    Regex.scan(~r/(http[^ ]+)/, msg)
    |> Enum.map(&List.first/1)
  end

  defp extract_title(url) do
    HTTPoison.start

    HTTPoison.get!(url).body
    |> Floki.find("title")
    |> Floki.text
  end
end
