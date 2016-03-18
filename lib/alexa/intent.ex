defmodule Alexa.Intent do
  alias Alexa.Intent

  defstruct [slots: nil, name: nil]

  def new(name, nil) do
    %Intent{ name: name }
  end

  def new(name, values) do
    %Intent{
      name: name,
      slots: convert_slot_values(values)
    }
  end

  defp convert_slot_values(slot_values) do
    Enum.reduce(slot_values, %{}, fn({k, v}, slots) ->
      Map.put(slots, k, %{ "name" => k, "value" => v })
    end)
  end

end
