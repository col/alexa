defmodule Alexa.User do
  alias Alexa.User

  defstruct userId: nil

  def new(user_id \\ nil) do
    %User{ userId: user_id }
  end

end
