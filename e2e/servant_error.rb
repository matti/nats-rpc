require_relative "../lib/nats/rpc"

servant = NATS::RPC::Servant.new
servant.serve 'errors', queue: "e2e" do |params, subject|
  asdf
end
