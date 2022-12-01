defmodule ProtocErlang.Generator do
  @moduledoc false

  @spec generate(%Google.Protobuf.FileDescriptorProto{}) ::
          [Google.Protobuf.Compiler.CodeGeneratorResponse.File.t()]
  def generate(file) do
    # NOTE(@ostera): make sure everything input into gpb is charlists and not binary strings
    with :ok <- :gpb_compile.file(:binary.bin_to_list(file), opts()) do
      for gen_file <- Path.wildcard("./**_pb.erl") do
        content = File.read!(gen_file)
        File.rm!(gen_file)
        Google.Protobuf.Compiler.CodeGeneratorResponse.File.new(
          name: gen_file,
          content: content
        )
      end
    end
  end

  defp opts() do
    [
      {:rename, {:msg_name, :snake_case}},
      {:rename, {:msg_fqname, :base_name}},
      :use_packages,
      :maps,
      :strings_as_binaries,
      {:i, '.'},
      {:report_errors, true},
      {:o, '.'},
      {:module_name_suffix, '_pb'},
      {:ignore_wellknown_types_directory, true}
    ]
  end
end
