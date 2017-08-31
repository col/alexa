defmodule Alexa.Card do
  defstruct [type: "Simple", title: nil, content: nil, text: nil, image: nil]

  def new(type, title, content) do
    %__MODULE__{type: type, title: title, content: content}
  end

  def new(type, title, content, text, image) do
    %__MODULE__{type: type, title: title, content: content, text: text, image: image}
  end
end
