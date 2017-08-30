defmodule Alexa.Directive do
  defstruct [type: "Display.RenderTemplate", template: %{}]

  def new(type, %{} = template) do
    %__MODULE__{type: type, template: template}
  end

  def from_params(params) do
    Poison.decode!(Poison.encode!(params), as: %__MODULE__{})
  end
end
