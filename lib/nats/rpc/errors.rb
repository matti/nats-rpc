module NATS
  module RPC
    class RemoteError < StandardError
      attr_accessor :remote_exception

      def to_s
        msg = super
        "#{self.remote_exception} (#{msg})"
      end

      def message
        super
      end
    end
  end
end
