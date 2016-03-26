defmodule Alexa.Skill do

  defmacro __using__(opts) do
    quote do
      use Application
      import Alexa.{Skill, Request, Response}
      require Logger

      @skill_opts unquote(opts)

      def start_link(opts \\ []) do
        app_ids = (opts[:app_id] || @skill_opts[:app_id]) |> List.wrap
        Enum.each(app_ids, &Alexa.Registry.register_skill(&1, __MODULE__))
        Logger.info("Registered #{__MODULE__} with AppId: #{Enum.join(app_ids, ", ")}")
        GenServer.start_link(__MODULE__, nil, name: __MODULE__)
      end

      def start(_type \\ nil, args \\ nil) do
        __MODULE__.start_link(args)
      end

      def handle_request(request) do
        Logger.debug("### Request ###")
        Logger.debug("#{inspect request}")
        # TODO: this is not using the skill process yet, it's just calling the handler directly.
        # TODO: ultimately each alexa session should spawn it's own process and the request
        # TODO: should be delegated to the correct process for handling.
        case type(request) do
          "LaunchRequest" -> handle_launch(request, empty_response)
          "IntentRequest" -> handle_intent(intent_name(request), request, empty_response)
          "SessionEndedRequest" -> handle_session_ended(request, empty_response)
        end
      end

      def handle_launch(_, response) do
        response
        |> say("Hi")
        |> should_end_session(false)
      end

      def handle_intent(_, _, response) do
        response
        |> say("Sorry, I don't know how to answer that.")
        |> should_end_session(false)
      end

      def handle_session_ended(_, response) do
        response
        |> say("Bye")
        |> should_end_session(true)
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

      defoverridable [handle_launch: 2, handle_intent: 3, handle_session_ended: 2]
    end
  end

end
