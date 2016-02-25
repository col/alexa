defmodule Alexa.Request do
  alias Alexa.{Session, RequestElement}

  defstruct [session: %Session{}, version: "1.0", request: %RequestElement{}]

  def applicationId(request) do
    case request.session.application do
      %{ applicationId: appId } -> appId
      _ -> nil
    end
  end

end
