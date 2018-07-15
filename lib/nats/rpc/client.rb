module NATS
  module RPC
    class Client
      def initialize(cluster_opts=nil)
        @nats = NATS::IO::Client.new
        @nats.connect cluster_opts || NATS::RPC.cluster_opts
      end

      def request(subscription, obj, opts)
        obj_json = if obj.is_a? String
          obj
        else
          obj.to_json
        end

        msg = @nats.request subscription, obj_json, opts
        data = JSON.parse(msg["data"])
        payload = JSON.parse(data["payload"])

        [data, payload]
      end
    end
  end
end
