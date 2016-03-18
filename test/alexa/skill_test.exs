defmodule Alexa.SkillTest do
  use ExUnit.Case
  alias Alexa.{Request, Response, RequestElement, Intent}

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

  defmodule TestSkill do
    use Alexa.Skill, app_id: "my-test-app-id"

    def handle_intent("TestIntent", request, response) do
      response
        |> Response.say("Hello. This is just a test skill.")
        |> Response.should_end_session(true)
    end
  end

  setup do
    if Alexa.Registry.get_skill("my-test-app-id") == Alexa.UnknownSkill do
      TestSkill.start
    end
    :ok
  end

  test "TestSkill - TestIntent" do
    request = Request.intent_request("my-test-app-id", "TestIntent")
    response = Alexa.handle_request(request)
    assert "Hello. This is just a test skill." = Response.say(response)
  end

end
