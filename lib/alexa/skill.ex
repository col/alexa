defmodule Alexa.Skill do

  def __using__(opts) do
    quote do
      import Alexa.Skill
      import Alexa.Request
      import Alexa.Response
      @skill_opts unquote(opts)
    end
  end

end
