defmodule Alexa.RequestTest do
  use ExUnit.Case
  alias Alexa.{Request, Session}

  test "applicationId" do
    request = %Request{ session: %Session{ application: %{ applicationId: "123" }}}
    appId = Request.applicationId(request)
    assert appId == "123"
  end

end
