defmodule Alexa.Session do
  defstruct [new: false, sessionId: nil, attributes: %{}, user: nil, application: %Alexa.Application{}]
end
