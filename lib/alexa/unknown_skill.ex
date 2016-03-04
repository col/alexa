defmodule Alexa.UnknownSkill do
  use Alexa.Skill, app_id: "UnknownSkill"

  def handle_intent(_, _, response) do
    say(response, "Sorry, I don't know how to answer that.")
  end

end
