defmodule Alexa.Response do
  alias Alexa.{ResponseElement, OutputSpeech}

  defstruct [version: "1.0", sessionAttributes: %{}, response: %ResponseElement{}]

  def say(request, text) do
    response_element = %{request.response | outputSpeech: OutputSpeech.plainSpeech(text)}
    %{request | response: response_element}
  end

  def empty_response() do
    %Alexa.Response{response: ResponseElement.empty_response}
  end

end
