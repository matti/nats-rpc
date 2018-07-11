$stdout.sync = true
require 'nats/io/client'
require 'json'

require_relative "rpc/version"
require_relative "rpc/servant"
require_relative "rpc/client"

module NATS
  module RPC
  end
end
