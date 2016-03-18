defmodule Alexa.Session do
  alias Alexa.{Session, Application}

  defstruct [new: false, sessionId: nil, attributes: %{}, user: nil, application: %Alexa.Application{}]

  def new(app_id, user_id, attributes \\ %{}) do
    user = case user_id do
      nil -> nil
      user_id -> %{ userId: user_id }
    end
    %Session{
      user: user,
      application: %Application{ applicationId: app_id },
      attributes: attributes
    }
  end

end
