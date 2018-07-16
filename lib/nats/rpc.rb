$stdout.sync = true
require 'nats/io/client'
require 'json'
require 'binding_of_caller'

require_relative "rpc/version"
require_relative "rpc/servant"
require_relative "rpc/client"
require_relative "rpc/errors"

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

    def self.stats(str)
      return unless ENV["NATS_RPC_STATS"] == "true"
      puts str
    end

    def self.debug(*args)
      return unless ENV["NATS_RPC_DEBUG"] == "true"

      calling_instance_or_class_name =  binding.of_caller(1).eval("self.class.name")
      calling_method_name = caller_locations(1,1)[0].label

      print "DEBUG #{calling_instance_or_class_name}##{calling_method_name} - "
      inspected_arg_strings = []
      for arg in args do
        inspected_arg_strings << if arg.is_a? String
          arg
        elsif
          arg.is_a? Array
          "\n" + arg.inspect.split("\",").join("\n")
        else
         arg.inspect
        end
      end

      puts inspected_arg_strings.join " "
    end
  end
end
