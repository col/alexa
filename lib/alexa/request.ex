defmodule Alexa.Request do
  alias Alexa.{Session, RequestElement, Request, Intent, User}

  defstruct [session: %Session{}, version: "1.0", request: %RequestElement{}]

  def intent_request(app_id, intent_name, user_id \\ nil, slot_values \\ nil, attributes \\ %{}) do
    %Request{
      session: Session.new(app_id, user_id, attributes),
      request: %RequestElement{
        type: "IntentRequest",
        intent: Intent.new(intent_name, slot_values)
      }
    }
  end

  def launch_request(app_id) do
    %Request{
      session: Session.new(app_id),
      request: %RequestElement{
        type: "LaunchRequest"
      }
    }
  end

  def application_id(request) do
    case request.session.application do
      %{ applicationId: appId } -> appId
      _ -> nil
    end
  end

  def intent_name(request) do
    request.request.intent.name
  end

  def type(request) do
    request.request.type
  end

  def slots(request) do
    Map.get(request.request.intent, :slots) || %{}
  end

  def slot_value(request, name) do
    slots(request)
    |> Map.get(name, %{})
    |> Map.get("value", nil)
  end

  def slot_attributes(request) do
    slots(request)
    |> Enum.reduce(%{}, fn({name, slot}, map) ->
      case Map.get(slot, "value") do
        nil -> map
        value -> Map.put(map, name, value)
      end
    end)
  end

  def from_params(params) do
    Poison.decode!(Poison.encode!(params), as: %Request{})
  end

  def attributes(request) do
    request.session.attributes
  end

  def attribute(request, key) do
    Map.get(attributes(request), key)
  end

  def set_attribute(request, key, value) do
    session = %{ request.session | attributes: Map.put(attributes(request), key, value) }
    %{ request | session: session }
  end

  def user_id(request) do
    Map.get(request.session, :user, User.new) |> Map.get(:userId)
  end

  def set_user_id(request, user_id) do
    session = %{ request.session | user: User.new(user_id) }
    %{ request | session: session }
  end
end
