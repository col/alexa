defmodule Alexa.ResponseTest do
  use ExUnit.Case
  alias Alexa.{Response, ResponseElement, OutputSpeech}

  test "say/2" do
    response = %Response{}
    response = Response.say(response, "Hello")
    assert response.response.outputSpeech.type == "PlainText"
    assert response.response.outputSpeech.text == "Hello"
  end

  test "say/1" do
    response = %Response{
      response: %ResponseElement{
        outputSpeech: %OutputSpeech{ text: "Hello World!" }
      }
    }
    say = Response.say(response)
    assert "Hello World!" = say
  end  

end
