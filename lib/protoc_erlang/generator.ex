defmodule Protobuf.Protoc.Generator do
  @moduledoc false

  @spec generate(%Google.Protobuf.FileDescriptorProto{}) ::
          [Google.Protobuf.Compiler.CodeGeneratorResponse.File.t()]
  def generate(%Google.Protobuf.FileDescriptorProto{} = desc) do
    :gpb_compile:
  end
end
