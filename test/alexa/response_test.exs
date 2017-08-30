defmodule Alexa.ResponseTest do
  use ExUnit.Case
  alias Alexa.{Request, Response, ResponseElement, OutputSpeech, Reprompt, Directive}

  test "say/2" do
    response = %Response{}
    response = Response.say(response, "Hello")
    assert response.response.outputSpeech.type == "PlainText"
    assert response.response.outputSpeech.text == "Hello"
    assert response.response.outputSpeech.ssml == nil
  end

  test "say/1" do
    response = %Response{
      response: %ResponseElement{
        outputSpeech: %OutputSpeech{ type: "PlainText", text: "Hello World!" }
      }
    }
    say = Response.say(response)
    assert "Hello World!" = say
  end

  test "say/1 when response is empty" do
    response = Response.empty_response
    say = Response.say(response)
    assert nil == say
  end

  test "say_ssml/2" do
    response = %Response{}
    response = Response.say_ssml(response, "<speak>Hello</speak>")
    assert response.response.outputSpeech.type == "SSML"
    assert response.response.outputSpeech.ssml == "<speak>Hello</speak>"
    assert response.response.outputSpeech.text == nil
  end

  test "say_ssml/1" do
    response = %Response{
      response: %ResponseElement{
        outputSpeech: %OutputSpeech{ type: "SSML", ssml: "<speak>Hello World!</speak>" }
      }
    }
    say = Response.say_ssml(response)
    assert "<speak>Hello World!</speak>" = say
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

  test "reprompt/1 when it's nil" do
    response = %Response{
      response: %ResponseElement{
        reprompt: nil
      }
    }
    assert is_nil(Response.reprompt(response))
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

  test "set_attribute/3" do
    response = Response.empty_response()
    response = Response.set_attribute(response, "Key", "Value")
    assert "Value" = Response.attribute(response, "Key")
  end

  test "remove_attribute/3" do
    response = Response.empty_response() |> Response.add_attribute("Key", "Value")
    assert Response.attribute(response, "Key")
    response = Response.remove_attribute(response, "Key")
    refute Response.attribute(response, "Key")
  end

  test "copy_attributes" do
    attributes = %{ "key1" => "value1" }
    request = Request.intent_request("test-1", "TestIntent", nil, nil, attributes)
    response = Response.copy_attributes(Response.empty_response(), request)
    assert Response.attributes(response) == attributes
  end

  test "card/4" do
    response = Response.empty_response
      |> Response.card("LinkAccount", "Link Account", "You can link your account here.")
    assert %Alexa.Card{type: "LinkAccount", title: "Link Account", content: "You can link your account here."} = Response.card(response)
  end

  test "directives/1" do
    directive_1 = %Directive{type: "Display.RenderTemplate", template: %{"title" => "a title 1"}}
    directive_2 = %Directive{type: "Display.RenderTemplate", template: %{"title" => "a title 2"}}
    response = %Response{
      response: %ResponseElement{
        directives: [directive_2, directive_1]
      }
    }
    assert [
      %Directive{type: "Display.RenderTemplate", template: %{"title" => "a title 2"}},
      %Directive{type: "Display.RenderTemplate", template: %{"title" => "a title 1"}}
    ] = Response.directives(response)
  end

  test "add_directive/2" do
    directive_params = %{
      type: "Display.RenderTemplate",
      template: %{
        title: "a title 1"
      }
    }
    directive_params_2 = put_in(directive_params, [:template, :title], "a title 2")
    response = Response.empty_response
      |> Response.add_directive(directive_params)
      |> Response.add_directive(directive_params_2)
    assert [
      %Directive{type: "Display.RenderTemplate", template: %{"title" => "a title 2"}},
      %Directive{type: "Display.RenderTemplate", template: %{"title" => "a title 1"}}
    ] = Response.directives(response)
  end
end
