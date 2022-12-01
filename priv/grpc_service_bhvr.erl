%%%-------------------------------------------------------------------
%% @doc Behaviour to implement for grpc service {{unmodified_service_name}}.
%% @end
%%%-------------------------------------------------------------------

%% this module was generated and should not be modified manually

-module({{module_name}}_bhvr).

{{#methods}}
{{^input_stream}}{{^output_stream}}-callback {{method}}({{pb_module}}:{{input}}(), grpc:metadata())
    -> {ok, {{pb_module}}:{{output}}(), grpc:metadata()}
     | {error, grpc_stream:error_response()}.

{{/output_stream}}{{/input_stream}}{{#input_stream}}{{^output_stream}}-callback {{method}}(grpc_stream:stream(), grpc:metadata())
    -> {ok, grpc_stream:stream()}.

{{/output_stream}}{{/input_stream}}{{#output_stream}}-callback {{method}}(grpc_stream:stream(), grpc:metadata())
    -> {ok, grpc_stream:stream()}.

{{/output_stream}}
{{/methods}}
