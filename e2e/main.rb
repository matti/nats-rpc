require_relative "../lib/nats/rpc"

servant_a = NATS::RPC::Servant.new id: "a"
servant_b = NATS::RPC::Servant.new id: "b"
servant_uuid = NATS::RPC::Servant.new

block = -> (params, subject) do
  puts "got params: #{params.inspect} in subject: #{subject}"
  params["reverse"].reverse
end

servant_a.serve 'testing', queue: "e2e", &block
servant_b.serve 'testing', queue: "e2e", &block
servant_uuid.serve 'testing', queue: "e2e", &block

sleep 0.5

10.times do
  load "e2e/client.rb"
end

servant_a.kill
servant_b.kill
servant_uuid.kill


