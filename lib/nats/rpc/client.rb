module NATS
  module RPC
    class Client
      def initialize(servers: ["nats://127.0.0.1:4222"])
        @nats = NATS::IO::Client.new
        @nats.connect servers: servers
      end

      def request(subscription, obj, opts)
        obj_json = if obj.is_a? String
          obj
        else
          obj.to_json
        end

        msg = @nats.request 'testing', obj_json, opts
        data = JSON.parse(msg["data"])
        payload = JSON.parse(data["payload"])

        [data, payload]
      end
    end
  end
end
