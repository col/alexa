defmodule Alexa.Response do
  alias Alexa.{Request, ResponseElement, OutputSpeech, Reprompt, Card, Directive}

  defstruct [version: "1.0", sessionAttributes: %{}, response: %ResponseElement{}]

  def say(response, text) do
    response_element = %{response.response | outputSpeech: OutputSpeech.plain_speech(text)}
    %{response | response: response_element}
  end

  def say(response) do
    response.response.outputSpeech.text
  end

  def say_ssml(response, text) do
    response_element = %{response.response | outputSpeech: OutputSpeech.ssml_speech(text)}
    %{response | response: response_element}
  end

  def say_ssml(response) do
    response.response.outputSpeech.ssml
  end

  def reprompt(response, text) do
    response_element = %{response.response | reprompt: %Reprompt{ outputSpeech: OutputSpeech.plain_speech(text) }}
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
    set_attribute(response, key, value)
  end

  def set_attribute(response, key, value) do
    %{ response | sessionAttributes: Map.put(response.sessionAttributes, key, value) }
  end

  def remove_attribute(response, key) do
    %{ response | sessionAttributes: Map.delete(response.sessionAttributes, key) }
  end

  def attributes(response) do
    response.sessionAttributes
  end

  def attributes(response, attributes) do
    %{response | sessionAttributes: attributes}
  end

  def copy_attributes(response, request) do
    attributes(response, Request.attributes(request))
  end

  def card(response, type, title, content) do
    card = Card.new(type, title, content)
    %{ response | response: %{response.response | card: card} }
  end

  def card(response) do
    response.response.card
  end

  def directives(response) do
    response.response.directives
  end

  def add_directive(response, %{} = directive) do
    directive = Directive.from_params(directive)
    %{ response | response: %{response.response | directives: [directive | response.response.directives]} }
  end
end
