defmodule Alexa.RequestElement do
  defstruct [intent: %Alexa.Intent{}, type: nil, requestId: nil, token: nil]
end
