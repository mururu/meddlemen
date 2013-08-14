defmodule Mix.Tasks.Meddlemen.Init do
  @shortdoc "Create a new Meddlemen project"
  
  @moduledoc """
  Creates a new Meddlemen project.

  ## Examples

      mix meddlemen.init hello_world

  """

  use Mix.Task

  import Mix.Generator
  import Mix.Utils, only: [camelize: 1, underscore: 1]

  def run(argv) do
    { opts, argv, _ } = OptionParser.parse(argv)
    case argv do
      [] ->
        raise Mix.Error, message: "expected PATH to be given, please use `mix meddlemen.init PATH`"
      [path|_] ->
        name = Path.basename(Path.expand(path))
        File.mkdir_p!(path)
        File.cd!(path, fn -> do_generate(name, opts) end)
    end
  end

  defp do_generate(app, opts) do
    mod = opts[:module] || camelize(app)

    assigns = [app: app, mod: mod]

    create_file ".gitignore", gitignore_text
    create_file "mix.lock",   mixlock_text
    create_file "mix.exs",    mix_template(assigns)

    create_directory "source"
    create_directory "source/layouts"
    create_directory "source/images"
    create_directory "source/javascripts"
    create_directory "source/stylesheets"

    create_file "source/index.html.eex", index_text
    create_file "source/layouts/layout.eex", layout_text
  end

  embed_text :gitignore, """
  /deps
  /ebin
  erl_crash.dump
  """

  embed_text :mixlock, ""

  embed_template :mix, %B"""
  defmodule <%= @mod %>.Mixfile do
    use Mix.Project

    def project do
      [ app: :<%= @app %>,
        version: "0.0.1",
        deps: deps ]
    end

    # Configuration for the OTP application
    def application do
    end

    defp deps do
    end
  end
  """

  embed_text :index, """
  <h1>Meddlemen</h1>
  <p class="doc">
    meddlemennnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn
  </p><!-- .doc -->
  """

  embed_text :layout, """
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="utf-8">

      <!-- Always force latest IE rendering engine or request Chrome Frame -->
      <meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible">

      <!-- Use title if it's in the page YAML frontmatter -->
      <title><%= current_page.data.title || "The Meddleman" %></title>
    </head>

    <body>
      <%= yield %>
    </body>
  </html>
  """
end
