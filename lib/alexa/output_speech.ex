defmodule Alexa.OutputSpeech do
  defstruct [type: nil, text: nil, ssml: nil]

  def plain_speech(text) do
    %Alexa.OutputSpeech{type: "PlainText", text: text}
  end

  def ssml_speech(text) do
    %Alexa.OutputSpeech{type: "SSML", ssml: text}
  end

end
