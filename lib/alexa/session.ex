defmodule Alexa.Session do
  alias Alexa.{Session, Application, User}

  defstruct [new: false, sessionId: nil, attributes: %{}, user: %User{}, application: %Application{}]

  def new(app_id, user_id \\ nil, attributes \\ %{}) do
    %Session{
      user: User.new(user_id),
      application: %Application{ applicationId: app_id },
      attributes: attributes
    }
  end

end
