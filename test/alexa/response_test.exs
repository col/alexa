defmodule Alexa.ResponseTest do
  use ExUnit.Case
  alias Alexa.{Response, ResponseElement, OutputSpeech, Reprompt}

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

  test "reprompt/2" do
    response = Response.reprompt(%Response{}, "What's your name?")
    assert response.response.reprompt.outputSpeech.type == "PlainText"
    assert response.response.reprompt.outputSpeech.text == "What's your name?"
  end

  test "reprompt/1" do
    response = %Response{
      response: %ResponseElement{
        reprompt: %Reprompt{
          outputSpeech: %OutputSpeech{
            type: "PlainText",
            text: "What's your name?"
          }
        }
      }
    }
    result = Response.reprompt(response)
    assert "What's your name?" = result
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

  test "attributes/1" do
    response = %Response{ sessionAttributes: %{ "Key" => "Value" } }
    assert %{ "Key" => "Value" } = Response.attributes(response)
  end

  test "attributes/2" do
    response = %Response{ sessionAttributes: %{ "Key" => "Value" } }
    response = Response.attributes(response, %{ "Key2" => "Value2" })
    assert %{ "Key2" => "Value2" } = Response.attributes(response)
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
