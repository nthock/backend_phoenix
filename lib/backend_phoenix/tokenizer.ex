defmodule Tokenizer do
  import Joken
  @secret "secret"

  def encode(map) do
    map
    |> token
    |> with_signer(hs256(@secret))
    |> sign
    |> get_compact
  end

  def decode(app_token) do
    app_token
    |> token
    |> with_signer(hs256(@secret))
    |> verify!
  end
end
