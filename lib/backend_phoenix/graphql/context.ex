defmodule GraphQL.Context do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    case build_context(conn) do
      {:ok, context} ->
        put_private(conn, :absinthe, %{context: context})

      {:error, reason} ->
        conn
        |> send_resp(403, reason)
        |> halt()

      _ ->
        conn
        |> send_resp(400, "Bad Request")
        |> halt()
    end
  end

  def build_context(conn) do
    user_ip = Enum.join(Tuple.to_list(conn.remote_ip), ".")
    {:ok, %{remote_ip: user_ip}}
  end
end
