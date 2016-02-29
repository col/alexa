defmodule Alexa.Response do
  alias Alexa.{ResponseElement, OutputSpeech}

  defstruct [version: "1.0", sessionAttributes: %{}, response: %ResponseElement{}]

  def say(response, text) do
    response_element = %{response.response | outputSpeech: OutputSpeech.plainSpeech(text)}
    %{response | response: response_element}
  end

  def say(response) do
    response.response.outputSpeech.text
  end

  def empty_response() do
    %Alexa.Response{response: ResponseElement.empty_response}
  end

  def should_end_session(response, value) do
    %{ response | response: %{response.response | shouldEndSession: value} }
  end

  def should_end_session(response) do
    response.response.shouldEndSession
  end

end
