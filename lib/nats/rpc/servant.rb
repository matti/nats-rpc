module NATS
  module RPC
    class Servant
      def initialize(id: SecureRandom.uuid, **cluster_opts)
        @id = id

        @nats = NATS::IO::Client.new
        @nats.connect cluster_opts || NATS::RPC.cluster_opts

        @count_json_parse_errors = 0
        @count_block_call_errors = 0
        @count_to_json_errors = 0
        @count_messages = 0

        @serve_thread = nil
      end

      def serve(subscribe_to, opts={}, &block)
        @serve_thread = Thread.new do
          self.serve! subscribe_to, opts, &block
        end
      end

      def kill
        return unless @serve_thread
        @serve_thread.kill
      end

      def serve!(subscribe_to, opts={}, &block)
        sid = @nats.subscribe subscribe_to, opts do |msg_json, reply, subject|
          params = nil
          json_parse_exception = nil
          begin
            params = JSON.parse(msg_json)
          rescue => ex
            @count_json_parse_errors = @count_json_parse_errors + 1
            json_parse_exception = ex
          end

          return @nats.publish reply, error_message(1.0, json_parse_exception.message) if json_parse_exception

          value = nil
          block_call_started_at = Time.now
          block_call_exception = nil
          begin
            value = block.call params, subject
          rescue => ex
            @count_block_call_errors = @count_block_call_errors + 1
            block_call_exception = ex
          end
          block_call_stopped_at = Time.now

          return @nats.publish reply, error_message(2.0, block_call_exception.message) if block_call_exception

          value_as_json = nil
          begin
            value_as_json = value.to_json
          rescue => ex
            @count_to_json_errors = @count_to_json_errors + 1
            value_to_json_exception = ex
          end

          return @nats.publish reply, error_message(3.0, value_to_json_exception.message) if value_to_json_exception

          response = {
            status: "ok",
            payload: value_as_json,
            took: (block_call_stopped_at - block_call_started_at).floor(2),
            servant: @id
          }

          @nats.publish(reply, response.to_json)

          @count_messages = @count_messages + 1
        end

        last_count_messages = 0
        loop do
          throughput = (last_count_messages - @count_messages).abs
          debug "s: #{subscribe_to} q: #{opts[:queue]} - msg: #{@count_messages} tput: #{throughput}/s errs json_parse: #{@count_json_parse_errors} block_call: #{@count_block_call_errors} to_json: #{@count_to_json_errors}"
          last_count_messages = @count_messages
          sleep 1
        end
      end

      private

      def error_message(code, data)
        {
          status: "error",
          code: code,
          payload: data.to_json,
          servant: @id
        }.to_json
      end

      def debug(str)
        return unless ENV["NATS_RPC_DEBUG"] == "true"
        puts str
      end
    end
  end
end
