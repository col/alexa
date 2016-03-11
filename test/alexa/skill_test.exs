defmodule Alexa.SkillTest do
  use ExUnit.Case
  alias Alexa.{Request, Response, RequestElement}

  test "handle_request - LaunchRequest - default response" do
    request = %Request{ request: %RequestElement{ type: "LaunchRequest" } }
    response = Alexa.handle_request(request)
    assert "Hi" = Response.say(response)
    assert false == Response.should_end_session(response)
  end

  test "handle_intent - IntentRequest - default response" do
    request = %Request{ request: %RequestElement{ type: "IntentRequest" } }
    response = Alexa.handle_request(request)
    assert "Sorry, I don't know how to answer that." = Response.say(response)
    assert false == Response.should_end_session(response)
  end

  test "handle_session_ended - SessionEndedRequest - default response" do
    request = %Request{ request: %RequestElement{ type: "SessionEndedRequest" } }
    response = Alexa.handle_request(request)
    assert "Bye" = Response.say(response)
    assert true == Response.should_end_session(response)
  end

end
