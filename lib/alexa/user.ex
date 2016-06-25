defmodule Alexa.User do
  alias Alexa.User

  defstruct userId: nil, accessToken: nil

  def new(user_id \\ nil, access_token \\ nil) do
    %User{ userId: user_id, accessToken: access_token }
  end

end
