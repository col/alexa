defmodule Alexa.Card do
  alias Alexa.Card
  defstruct [type: "Simple", title: nil, content: nil]

  def new(type, title, content) do
    %Card{type: type, title: title, content: content}
  end
end
