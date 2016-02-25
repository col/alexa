defmodule Alexa.ResponseTest do
  use ExUnit.Case
  alias Alexa.Response

  test "say" do
    response = %Response{}
    response = Response.say(response, "Hello")
    assert response.response.outputSpeech.type == "PlainText"
    assert response.response.outputSpeech.text == "Hello"
  end

end
