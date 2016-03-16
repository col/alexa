# Alexa

Provides support for implementing an Amazon Alexa Skill.

## Installation

The package can be installed as:

  1. Add alexa to your list of dependencies in `mix.exs`:

        def deps do
          [{:alexa, "~> 0.1.6"}]
        end

  2. Add alexa to your list of applications in `mix.exs`:

        def application do
          [applications: [:logger, :alexa]]
        end

## Usage

Creating a new Alexa skill is easy.

    defmodule MyAwesomeSkill do
      use Alexa.Skill, app_id: "<alexa_skill_app_id>"      

      def handle_intent("SayHello", request, response) do
        response |> say("Hello World!")
      end
    end

This will register your skill with the Alexa module. It will be used to
handle any incoming requests with the matching app_id.

Then create an app that exposes an endpoint so that you can receive incoming
Alexa requests.

Here's an example plug implementation:

    defmodule Router do
      use Plug.Router

      plug :match
      plug :dispatch

      post "/command" do
        {:ok, body, conn} = read_body(conn)
        request = Poison.decode!(body, as: %Alexa.Request{})
        response = Alexa.handle_request(request)
        conn = send_resp(conn, 200, Poison.encode!(response))
        conn = %{conn | resp_headers: [{"content-type", "application/json"}]}
        conn
      end
    end
