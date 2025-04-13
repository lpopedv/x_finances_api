defmodule Finances.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:ecto_erd, "~> 0.6", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      "ecto.migrate": ["ecto.migrate", &maybe_ecto_dump/1, &maybe_schema_dump/1],
      "ecto.rollback": ["ecto.rollback", &maybe_ecto_dump/1, &maybe_schema_dump/1]
    ]
  end

  defp maybe_ecto_dump(_) do
    if Mix.env() == :dev do
      Mix.Task.run("ecto.dump")
    end
  end

  defp maybe_schema_dump(_) do
    if Mix.env() == :dev do
      Mix.Task.run("ecto.gen.erd", ["--output-path=erd.puml"])

      File.cp!("erd.puml", "apps/core/priv/repo/erd.plantuml")
      File.rm!("erd.puml")
    end
  end
end
