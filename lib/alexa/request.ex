defmodule Alexa.Request do
  alias Alexa.{Session, RequestElement, Request}

  defstruct [session: %Session{}, version: "1.0", request: %RequestElement{}]

  def application_id(request) do
    case request.session.application do
      %{ applicationId: appId } -> appId
      _ -> nil
    end
  end

  def from_params(params) do
    Poison.decode!(Poison.encode!(params), as: Request)
  end

end
