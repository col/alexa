defmodule Alexa.RequestTest do
  use ExUnit.Case
  alias Alexa.{Request, Session, RequestElement, Intent, User}

  test "new intent_request helper" do
    request = Request.intent_request("app_id", "intent_name", "user_id")
    assert Request.application_id(request) == "app_id"
    assert Request.intent_name(request) == "intent_name"
    assert Request.user_id(request) == "user_id"
  end

  test "new intent_request helper with access token" do
    request = Request.intent_request("app_id", "intent_name", "user_id", nil, %{}, "user-access-token")
    assert Request.application_id(request) == "app_id"
    assert Request.intent_name(request) == "intent_name"
    assert Request.access_token(request) == "user-access-token"
  end

  test "new intent_request helper - slot_values" do
    request = Request.intent_request("app_id", "intent_name", "user_id", %{ "sample_key" => "sample_value" })
    assert Request.application_id(request) == "app_id"
    assert Request.intent_name(request) == "intent_name"
    assert Request.user_id(request) == "user_id"
  end

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

  test "set_slot_value" do
    request = Request.intent_request("app_id", "SampleRequest", nil, %{"SampleKey" => "SampleValue"})
    assert "SampleValue" = Request.slot_value(request, "SampleKey")

    request = Request.set_slot_value(request, "SampleKey", "NewSlotValue")
    assert "NewSlotValue" = Request.slot_value(request, "SampleKey")
  end

  test "remove_slot" do
    request = Request.intent_request("app_id", "SampleRequest", nil, %{"SampleKey" => "SampleValue"})
    assert "SampleValue" = Request.slot_value(request, "SampleKey")

    request = Request.remove_slot(request, "SampleKey")
    assert is_nil(Request.slot_value(request, "SampleKey"))
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

  test "slot_attributes ignores slots with no value" do
    intent = %Intent{ slots: %{
      "key1" => %{ "name" => "key1", "value" => "100" },
      "key2" => %{ "name" => "key2" }
    }}
    request = %Request{ request: %RequestElement{ intent: intent } }
    result = Request.slot_attributes(request)
    assert %{ "key1" => "100" } = result
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

  test "attribute - does not crash when attributes is nil" do
    request = %Request{ session: %Session{ attributes: nil }}
    result = Request.attribute(request, "key")
    assert result == nil
  end

  test "set_attribute/3" do
    request = %Request{ session: %Session{ attributes: %{ "key" => "value" } }}
    request = Request.set_attribute(request, "key2", "value2")
    assert %{ "key" => "value", "key2" => "value2" } == Request.attributes(request)
  end

  test "set_attribute/3 - replaces existing keys" do
    request = %Request{ session: %Session{ attributes: %{ "key" => "value" } }}
    request = Request.set_attribute(request, "key", "value2")
    assert %{ "key" => "value2" } == Request.attributes(request)
  end

  test "user_id" do
    request = %Request{ session: %Session{ user: User.new("user123") } }
    user_id = Request.user_id(request)
    assert "user123" = user_id
  end

  test "set_user_id" do
    request = %Request{ session: %Session{ user: User.new("user123") } }
    request = Request.set_user_id(request, "new_user_id")
    assert "new_user_id" = Request.user_id(request)
  end

  test "access_token" do
    request = %Request{ session: %Session{ user: User.new("user123", "user-access-token") } }
    access_token = Request.access_token(request)
    assert "user-access-token" = access_token
  end

  test "set_access_token" do
    request = %Request{ session: %Session{ user: User.new("user123") } }
    request = Request.set_access_token(request, "new-user-access-token")
    assert "new-user-access-token" = Request.access_token(request)
  end

  test "new_session? - when new" do
    request = %Request{ session: %Session{ new: true } }
    assert Request.new_session?(request)
  end

  test "new_session? - when not new" do
    request = %Request{ session: %Session{ new: false } }
    refute Request.new_session?(request)
  end
end
