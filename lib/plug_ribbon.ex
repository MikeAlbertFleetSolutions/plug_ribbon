defmodule Plug.Ribbon do
  import Plug.Conn

  @moduledoc """
  Module for injecting a ribbon depending on the environment.

  ## Usage

  Add the `Plug.Ribbon` plug to your router and specify the environment

      plug Plug.Ribbon, [:dev, :staging]

  """

  @behaviour Plug
  @external_resource ribbon_css_path = "priv/static/plug-ribbon.min.css"
  @external_resource ribbon_ie_css_path = "priv/static/plug-ribbon.ie.min.css"
  @ribbon_css File.read!(ribbon_css_path)
  @ribbon_ie_css File.read!(ribbon_ie_css_path)

  def init(default), do: default

  def call(conn, text) do
    add_ribbon(conn, text)
  end

  defp add_ribbon(conn, text) do
    register_before_send conn, fn conn ->
      resp_body = to_string(conn.resp_body)
      if inject?(conn, resp_body) do
        [page | rest] = String.split(resp_body, "</body>")
        body = page <> add_ribbon_markup(text) <> Enum.join(["</body>" | rest], "")

        put_in conn.resp_body, body
      else
        conn
      end
    end
  end

  defp inject?(conn, resp_body) do
    conn
    |> get_resp_header("content-type")
    |> html_content_type?
    |> Kernel.&&(String.contains?(resp_body, "<body"))
  end
  defp html_content_type?([]), do: false
  defp html_content_type?([type | _]), do: String.starts_with?(type, "text/html")

  defp add_ribbon_markup(text) do
    """
    <!-- Plug Ribbon -->
    <style>#{@ribbon_css}</style>
    <!--[if lt IE 9]>
    <style>#{@ribbon_ie_css}</style>
    <![endif]-->
    <style>
    .plug-ribbon {
      background-image: radial-gradient( circle at 50% 50%, #815dc1 29%, #4e2a8e 120%);
      //background-color: #815dc1;
    }
    </style>
    <div class="plug-ribbon-wrapper right">
      <div class="plug-ribbon">
        <a href="/">#{text}</a>
      </div>
    </div>
    <!-- /Plug Ribbon -->
    """
  end
end
