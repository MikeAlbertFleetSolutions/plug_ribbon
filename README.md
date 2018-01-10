# plug_ribbon

This [Plug](https://github.com/elixir-lang/plug) module injects a ribbon to your web application.

Used to differentiate between environments.

This was forked from [stnly/plug_ribbon](https://github.com/stnly/plug_ribbon), this version is safe to use in exrm & distillery releases.

## Setup

To use plug_ribbon in your projects, edit your `mix.exs` file and add plug_ribbon as a dependency:

```elixir
defp deps do
  [
    {:plug_ribbon, github: "MikeAlbertFleetSolutions/plug_ribbon"}
  ]
end
```

## Usage

This plug should be one of the last ones in your pipeline.

Add the plug for the specific environments that you want the ribbon to be shown, include the text to be shown.

```elixir
defmodule MyPhoenixApp.Router do
  use MyPhoenixApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    unless Mix.env == :prod do
      plug Plug.Ribbon, "Not Prod"
    end
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MyPhoenixApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Observes do
  #   pipe_through :api
  # end
end
```

After you are done, run `mix deps.get` in your shell to fetch the dependencies.

The ribbon will display the specified label.

## Testing

```bash
$ mix test
```

## Build notes:

#### To create docker image:

```bash
$ docker build --pull --tag plug_ribbon -f Dockerfile .
```

#### To create docker container from image during development:

```bash
$ docker run -it --rm -v c:/Users/brian.bathe/Documents/workspace/plug_ribbon:/app -w /app plug_ribbon
```
