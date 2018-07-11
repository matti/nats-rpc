require_relative "../lib/nats/rpc"

client = NATS::RPC::Client.new
data, payload = client.request 'testing', {reverse: "hello"}, timeout: 1, queue: 'e2e'

puts data
puts payload
