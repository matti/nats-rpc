require_relative "../lib/nats/rpc"

servant = NATS::RPC::Servant.new
servant.serve! 'testing', queue: "e2e" do |params, subject|
  puts "got params: #{params.inspect} in subject: #{subject}"
  params["reverse"].reverse
end
