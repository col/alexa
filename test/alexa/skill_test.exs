defmodule Alexa.SkillTest do
  use ExUnit.Case
  alias Alexa.{Request, Response, RequestElement, Session}

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

  test "handle_intent - IntentRequest - session attributes are copied to response" do
    request = %Request{ request: %RequestElement{ type: "IntentRequest" },
                        session: %Session {attributes: %{"one": "value"}}}
    response = Alexa.handle_request(request)
    assert "value" == Response.attribute(response,:one)
  end

  test "handle_intent - Display.ElementSelected - default response" do
    request = %Request{ request: %RequestElement{ type: "Display.ElementSelected" } }
    response = Alexa.handle_request(request)
    assert "Sorry, no action has been set up." = Response.say(response)
    assert false == Response.should_end_session(response)
  end

  test "handle_intent - Display.ElementSelected - session attributes are copied to response" do
    request = %Request{ request: %RequestElement{ type: "Display.ElementSelected" },
                        session: %Session {attributes: %{"one": "value"}}}
    response = Alexa.handle_request(request)
    assert "value" == Response.attribute(response,:one)
  end

  test "handle_session_ended - SessionEndedRequest - default response" do
    request = %Request{ request: %RequestElement{ type: "SessionEndedRequest" } }
    response = Alexa.handle_request(request)
    assert "Bye" = Response.say(response)
    assert true == Response.should_end_session(response)
  end

  defmodule TestSkill do
    use Alexa.Skill, app_id: "my-test-app-id"

    def handle_intent("TestIntent", _, response) do
      response
        |> Response.say("Hello. This is just a test skill.")
        |> Response.should_end_session(true)
    end
  end

  setup do
    if Alexa.Registry.get_skill("my-test-app-id") == Alexa.UnknownSkill do
      TestSkill.start_link
    end
    :ok
  end

  test "TestSkill.start_link - registers the skill with the app_id" do
    assert TestSkill = Alexa.Registry.get_skill("my-test-app-id")
  end

  test "TestSkill.start_link - uses the app_id provided in the options (if provided)" do
    TestSkill.start_link([app_id: "different-app-id"])
    assert TestSkill = Alexa.Registry.get_skill("different-app-id")
  end

  test "TestSkill.start_link - registers the skill with multiple app_id's when given an array" do
    TestSkill.start_link([app_id: ["app-id-1", "app-id-2"]])
    assert TestSkill = Alexa.Registry.get_skill("app-id-1")
    assert TestSkill = Alexa.Registry.get_skill("app-id-2")
  end

  test "TestSkill - TestIntent" do
    request = Request.intent_request("my-test-app-id", "TestIntent")
    response = Alexa.handle_request(request)
    assert "Hello. This is just a test skill." = Response.say(response)
  end

end
