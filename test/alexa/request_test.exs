defmodule Alexa.RequestTest do
  use ExUnit.Case
  alias Alexa.{Request, Session}

  test "application_id" do
    request = %Request{ session: %Session{ application: %{ applicationId: "123" }}}
    appId = Request.application_id(request)
    assert appId == "123"
  end

  test "from_params" do
    {:ok, request_body} = File.read("samples/request.json")
    params = Poison.decode!(request_body)
    request = Request.from_params(params)
    assert request == Poison.decode!(request_body, as: Request)
  end

end
