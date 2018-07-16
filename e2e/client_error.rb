require_relative "../lib/nats/rpc"

client = NATS::RPC::Client.new
begin
  data, payload = client.request 'errors', {}, timeout: 1, queue: 'e2e'
rescue NATS::RPC::RemoteError => rex
  puts rex.remote_exception
  puts rex
  puts rex.backtrace.join("\n")

  raise "remote_exception" unless rex.remote_exception == "NameError"
  raise "rex" unless rex.to_s == "NameError (undefined local variable or method `asdf' for main:Object)"
  raise "backtrace" unless rex.backtrace[0] == "e2e/servant_error.rb:5:in `block in <top (required)>'"
end
