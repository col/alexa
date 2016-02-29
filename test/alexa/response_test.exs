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

  test "should_end_session/1" do
    response = %Response{ response: %ResponseElement{shouldEndSession: false} }
    value = Response.should_end_session(response)
    assert false == value
  end

  test "should_end_session/2" do
    response = %Response{ response: %ResponseElement{shouldEndSession: false} }
    response = Response.should_end_session(response, true)
    assert true == Response.should_end_session(response)
  end  

  test "attribute/2" do
    response = %Response{ sessionAttributes: %{ "Key" => "Value" } }
    assert "Value" = Response.attribute(response, "Key")
  end

  test "add_attribute/3" do
    response = Response.empty_response()
    response = Response.add_attribute(response, "Key", "Value")
    assert "Value" = Response.attribute(response, "Key")
  end

end
