$stdout.sync = true
require 'nats/io/client'
require 'json'

require_relative "rpc/version"
require_relative "rpc/servant"
require_relative "rpc/client"

module NATS
  module RPC
    def self.cluster_opts
      servers = ENV['NATS_RPC_SERVER_URLS']&.split(",")
      max_reconnect_attempts = ENV['NATS_RPC_MAX_RECONNECT_ATTEMPTS']&.to_i
      reconnect_time_wait = ENV['NATS_RPC_RECONNECT_TIME_WAIT']&.to_i

      opts = {}
      opts[:servers] = servers if servers
      opts[:max_reconnect_attempts] = max_reconnect_attempts if max_reconnect_attempts
      opts[:reconnect_time_wait] = reconnect_time_wait if reconnect_time_wait
      if ENV['NATS_RPC_DONT_RANDOMIZE_SERVERS']
        opts[:dont_randomize_servers] = ENV['NATS_RPC_DONT_RANDOMIZE_SERVERS'] == "true"
      end
      if ENV['NATS_RPC_RECONNECT']
        opts[:reconnect] = ENV['NATS_RPC_RECONNECT'] == "true"
      end

      opts
    end
  end
end
