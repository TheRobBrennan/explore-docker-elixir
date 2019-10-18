defmodule Hello.Repo do
  use Ecto.Repo, otp_app: :hello, adapter: Ecto.Adapters.Postgres

  # Define fallback values that match hello/config/dev.exs in case we are developing without Docker
  def init(_, config) do
    config = config
      |> Keyword.put(:username, System.get_env("PGUSER") || "postgres")
      |> Keyword.put(:password, System.get_env("PGPASSWORD") || "postgres")
      |> Keyword.put(:database, System.get_env("PGDATABASE") || "hello_dev")
      |> Keyword.put(:hostname, System.get_env("PGHOST") || "localhost")
      |> Keyword.put(:port, (System.get_env("PGPORT") || "5432") |> String.to_integer)
    {:ok, config}
  end
end
