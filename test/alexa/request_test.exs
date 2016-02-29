defmodule Alexa.RequestTest do
  use ExUnit.Case
  alias Alexa.{Request, Session, RequestElement, Intent}

  test "application_id" do
    request = %Request{ session: %Session{ application: %{ applicationId: "123" }}}
    appId = Request.application_id(request)
    assert appId == "123"
  end

  test "intent_name" do
    request = %Request{ request: %RequestElement{ intent: %Intent{ name: "SampleName" }} }
    intent_name = Request.intent_name(request)
    assert "SampleName" = intent_name
  end

  test "slots" do
    slots = %{ "testKey" => %{ "name" => "testKey", "value" => "testValue" } }
    request = %Request{ request: %RequestElement{ intent: %Intent{ slots: slots } } }
    result = Request.slots(request)
    assert slots == result
  end

  test "slot_value" do
    dollarAmountSlot = %{ "name" => "dollarAmount", "value" => "100" }
    intent = %Intent{ name: "SampleName", slots: %{ "dollarAmount" => dollarAmountSlot } }
    request = %Request{ request: %RequestElement{ intent: intent } }
    slot_value = Request.slot_value(request, "dollarAmount")
    assert "100" = slot_value
  end

  test "slot_value returns nil when not found" do
    request = %Request{}
    slot_value = Request.slot_value(request, "dollarAmount")
    assert nil == slot_value
  end

  test "slot_attributes returns the slot values in a simple map" do
    intent = %Intent{ slots: %{
      "key1" => %{ "name" => "key1", "value" => "100" },
      "key2" => %{ "name" => "key2", "value" => "200" }
    }}
    request = %Request{ request: %RequestElement{ intent: intent } }
    result = Request.slot_attributes(request)
    assert %{ "key1" => "100", "key2" => "200" } = result
  end

  test "from_params" do
    {:ok, request_body} = File.read("samples/request.json")
    params = Poison.decode!(request_body)
    request = Request.from_params(params)
    assert request == Poison.decode!(request_body, as: %Request{})
  end

  test "attributes" do
    attributes = %{ "key" => "value" }
    request = %Request{ session: %Session{ attributes: attributes }}
    result = Request.attributes(request)
    assert result == attributes
  end

  test "attribute" do
    request = %Request{ session: %Session{ attributes: %{ "key" => "value" } }}
    result = Request.attribute(request, "key")
    assert "value" == result
  end

  test "user_id" do
    request = %Request{ session: %Session{ user: %{ "userId" => "user123" } }}
    user_id = Request.user_id(request)
    assert "user123" = user_id
  end
end
