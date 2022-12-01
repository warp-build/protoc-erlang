defmodule ProtocErlang.MixProject do
  use Mix.Project

  def project do
    [
      app: :protoc_erlang,
      version: "4.19.6",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      escript: escript(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :gpb, :protobuf]
    ]
  end

  defp escript do
    [main_module: ProtocErlang.CLI, name: "protoc-gen-erlang"]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gpb, "~> 4.19.6"},
      {:protobuf, "~> 0.11"}
    ]
  end
end
