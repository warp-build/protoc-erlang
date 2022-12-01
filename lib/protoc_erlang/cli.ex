defmodule ProtocErlang.CLI do
  @moduledoc """
  `protoc` plugin for generating Erlang code.

  `protoc-gen-erlang` (this name is important) **must** be in `$PATH`. You are not supposed
  to call it directly, but only through `protoc`.

  ## Examples

      $ protoc --erlang_out=./lib your.proto
      $ protoc --erlang_out=plugins=grpc:./lib/ *.proto
      $ protoc -I protos --erlang_out=./lib protos/namespace/*.proto

  """

  # Entrypoint for the escript (protoc-gen-erlang).
  @doc false
  @spec main([String.t()]) :: :ok
  def main(args)

  def main(["--version"]) do
    {:ok, version} = :application.get_key(:protobuf, :vsn)
    IO.puts(version)
  end

  # When called through protoc, all input is passed through stdin.
  def main([] = _args) do
    Protobuf.load_extensions()

    # See https://groups.google.com/forum/#!topic/elixir-lang-talk/T5enez_BBTI.
    :io.setopts(:standard_io, encoding: :latin1)

    # Read the standard input that protoc feeds us.
    bin = binread_all!(:stdio)

    request = Protobuf.Decoder.decode(bin, Google.Protobuf.Compiler.CodeGeneratorRequest)

    files =
      Enum.flat_map(request.file_to_generate, fn file ->
        ProtocErlang.Generator.generate(desc)
      end)

    Google.Protobuf.Compiler.CodeGeneratorResponse.new(
      file: files,
      supported_features: supported_features()
    )
    |> Protobuf.encode_to_iodata()
    |> IO.binwrite()
  end

  def main(_args) do
    raise "invalid arguments. See protoc-gen-erlang --help."
  end

  if Version.match?(System.version(), "~> 1.13") do
    defp binread_all!(device) do
      case IO.binread(device, :eof) do
        data when is_binary(data) -> data
        :eof -> _previous_behavior = ""
        other -> raise "reading from #{inspect(device)} failed: #{inspect(other)}"
      end
    end
  else
    defp binread_all!(device) do
      case IO.binread(device, :all) do
        data when is_binary(data) -> data
        other -> raise "reading from #{inspect(device)} failed: #{inspect(other)}"
      end
    end
  end
end

