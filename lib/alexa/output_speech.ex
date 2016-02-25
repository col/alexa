defmodule Alexa.OutputSpeech do
  defstruct [type: nil, text: nil]

  def plainSpeech(text) do
    %Alexa.OutputSpeech{type: "PlainText", text: text}
  end

end
