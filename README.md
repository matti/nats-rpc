# nats-rpc

```
gem install 'nats-rpc'
```

## usage

servant.rb
```ruby
require "nats-rpc"

servant = NATS::RPC::Servant.new
servant.serve! 'testing', queue: 'test' do |params, subject|
  puts "got params: #{params.inspect} in subject: #{subject}"

  params["reverse"].reverse
end
```

client.rb
```ruby
client = NATS::RPC::Client.new
msg = {reverse: "hello"}
data, payload = client.request 'testing', msg, timeout: 1, queue: 'test'

puts data
# => {"status"=>"ok", "payload"=>"\"olleh\"", "took"=>0.0, "servant"=>"112a1f87-2d01-4339-a30d-ddc542ccd383"}
puts payload
# => olleh
```

## advanced usage

servant.rb
```ruby
require "nats-rpc"

cluster_opts = {
  servers: ["nats://127.0.0.1:4222", "nats://127.0.0.1:4223"],
  dont_randomize_servers: true,
  reconnect_time_wait: 0.5,
  max_reconnect_attempts: 2
}

servant = NATS::RPC::Servant.new id: "a", cluster_opts
servant.serve! 'testing' do |params, subject|
  puts "got params: #{params.inspect} in subject: #{subject}"

  params["reverse"].reverse
end

# client requests show that they were served from servant "a"
# => {"status"=>"ok", "payload"=>"\"olleh\"", "took"=>0.0, "servant"=>"a"}
```

## testing

see `e2e/` and `docker-compose.yml`

