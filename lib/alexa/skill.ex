defmodule Alexa.Skill do

  defmacro __using__(opts) do
    quote do
      use Application
      import Alexa.{Skill, Request, Response}
      require Logger

      @skill_opts unquote(opts)

      # TODO: Still learning the OTP stuff.. seems I need a 'start_link' for
      # TODO: Supervisors and 'start' to start it as an application.
      # TODO: Ultimately I'd like to support both if that's possible.
      def start_link(opts \\ []) do
        app_id = @skill_opts[:app_id]
        Alexa.Registry.register_skill(app_id, __MODULE__)
        Logger.info("Registered #{__MODULE__} with AppId: #{app_id}")
        GenServer.start_link(__MODULE__, nil, name: String.to_atom(app_id))
      end

      def start(_type, _args) do
        app_id = @skill_opts[:app_id]
        Alexa.Registry.register_skill(app_id, __MODULE__)
        Logger.info("Registered #{__MODULE__} with AppId: #{app_id}")
        GenServer.start(__MODULE__, nil, name: String.to_atom(app_id))
      end

      def handle_request(request) do
        # TODO: this is not using the skill process yet, it's just calling the handler directly.
        # TODO: ultimately each alexa session should spawn it's own process and the request
        # TODO: should be delegated to the correct process for handling.
        handle_intent(intent_name(request), request, empty_response)
      end

      def handle_intent(_, _, response) do
        say(response, "Sorry, I'm not sure what you're on about.")
      end

      def init(_) do
        {:ok, nil}
      end

      def handle_cast(_, state) do
        {:noreply, state}
      end

      def handle_call(_, _, state) do
        {:noreply, nil, state}
      end

      defoverridable [handle_intent: 3]
    end
  end

end
