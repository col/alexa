defmodule Alexa.ResponseElement do
  alias Alexa.{OutputSpeech, Card, Reprompt}
  defstruct [outputSpeech: %OutputSpeech{}, card: %Card{}, reprompt: %Reprompt{}, shouldEndSession: true, directives: []]

  def empty_response() do
    %Alexa.ResponseElement{outputSpeech: %OutputSpeech{}, card: nil, reprompt: nil, shouldEndSession: true}
  end

end
