defmodule Alexa.Response do
  alias Alexa.{ResponseElement, OutputSpeech, Reprompt}

  defstruct [version: "1.0", sessionAttributes: %{}, response: %ResponseElement{}]

  def say(response, text) do
    response_element = %{response.response | outputSpeech: OutputSpeech.plainSpeech(text)}
    %{response | response: response_element}
  end

  def say(response) do
    response.response.outputSpeech.text
  end

  def reprompt(response, text) do
    response_element = %{response.response | reprompt: %Reprompt{ outputSpeech: OutputSpeech.plainSpeech(text) }}
    %{response | response: response_element}
  end

  def reprompt(response) do
    reprompt = Map.get(response.response, :reprompt) || %Reprompt{}
    outputSpeech = Map.get(reprompt, :outputSpeech) || %OutputSpeech{}
    outputSpeech.text
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

  def attribute(response, key) do
    Map.get(response.sessionAttributes, key)
  end

  def add_attribute(response, key, value) do
    %{ response | sessionAttributes: Map.put(response.sessionAttributes, key, value) }
  end

  def attributes(response) do
    response.sessionAttributes
  end

  def attributes(response, attributes) do
    %{response | sessionAttributes: attributes}
  end

end
