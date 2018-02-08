defmodule Mix.Tasks.Minify do
  use Mix.Task

  @moduledoc """
  Module for minifying this projects css.

  ## Usage

      mix minify

  """

  def run(_) do
    Mix.shell().info("Minifying plug-ribbon.css ...")

    :os.cmd(
      'curl -X POST -s --data-urlencode "input@priv/static/plug-ribbon.css" https://cssminifier.com/raw > "priv/static/plug-ribbon.min.css"'
    )

    Mix.shell().info("Completed minify task")
  end
end
